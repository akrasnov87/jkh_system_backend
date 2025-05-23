module ServicePayments
  class Creator
    include Helpers

    attr_reader :service_order, :order_sum, :rq_uid, :service_payment

    MAX_RETRY = 5

    def initialize(service_order, params)
      @service_order = service_order
      @order_sum = params[:order_sum]
      @rq_uid = SecureRandom.uuid.delete('-')
      @retry_count = 0
    end

    def call
      @service_payment = ServicePayment.create(service_order:, order_sum:, rq_uid:, id_qr: fetch_id_qr)
      response = send_sber_request

      body = if response.body.is_a?(Hash)
               response.body.deep_symbolize_keys
             else
               JSON.parse(response.body).deep_symbolize_keys
             end
      update_service_payment(body)
      @service_payment
    end

    def send_sber_request
      @retry_count += 1
      response = ServicePayments::Gateway.new.create_payment(fetch_request_params)

      return response if response.status == 200

      Rails.logger.warn "Payment request error #{response.body} #{response.status}"
      sleep(5)
      send_sber_request if @retry_count < MAX_RETRY
    rescue StandardError => e
      Rails.logger.warn "Payment request error #{e} #{response.body}"
      sleep(5)
      send_sber_request if @retry_count < MAX_RETRY
    end

    def update_service_payment(body)
      service_payment.update(
        order_form_url: body[:formUrl],
        order_id: body[:orderId]
      )
    end

    def converted_sum
      (order_sum.to_f * 100).to_i
    end

    def fetch_request_params
      {
        userName: fetch_user_name,
        password: fetch_user_password,
        orderNumber: service_payment.id.to_s,
        amount: converted_sum,
        returnUrl: '',
        description: "Оплата услуг #{service_payment.service_order.subject} сумма #{order_sum} руб.",
        expirationDate: date_format(Time.current + 24.hours),
        jsonParams: {
          qrType: 'DYNAMIC_QR_SBP',
          'sbp.scenario' => 'C2B'
        }
      }
    end
  end
end
