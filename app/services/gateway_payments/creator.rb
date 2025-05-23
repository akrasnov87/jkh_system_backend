module GatewayPayments
  class Creator
    include Helpers
    attr_reader :account, :order_sum, :kind, :rq_uid, :payment, :company

    MAX_RETRY = 1

    def initialize(account, params)
      @account = account
      @company = account.company
      @order_sum = params[:order_sum]
      @kind = :gateway
      @rq_uid = SecureRandom.uuid.delete('-')
      @retry_count = 0
    end

    def call
      @payment = Payment.create(account:, order_sum:, rq_uid:, kind:, id_qr: fetch_id_qr)
      response = send_sber_request

      body = if response.body.is_a?(Hash)
               response.body.deep_symbolize_keys
             else
               JSON.parse(response.body).deep_symbolize_keys
             end
      update_payment(body)
      @payment
    end

    def converted_sum
      (order_sum.to_f * 100).to_i
    end

    def send_sber_request
      @retry_count += 1
      response = Sber::Gateway.new(company).create_payment(fetch_request_params)

      return response if response.status == 200

      Rails.logger.warn "Payment request error #{response.body} #{response.status}"
      sleep(5)
      send_sber_request if @retry_count < MAX_RETRY
    rescue StandardError => e
      Rails.logger.warn "Payment request error #{e} #{response}"
      sleep(5)
      send_sber_request if @retry_count < MAX_RETRY
    end

    def update_payment(body)
      payment.update(
        order_form_url: body[:formUrl],
        order_id: body[:orderId]
      )
    end

    def fetch_request_params
      {
        userName: fetch_user_name,
        password: fetch_user_password,
        orderNumber: payment.id.to_s,
        amount: converted_sum,
        returnUrl: '',
        description: "Оплата лицевого счета #{account.number} сумма #{order_sum} руб.",
        expirationDate: date_format(Time.current + 20.minutes),
        jsonParams: {
          qrType: 'DYNAMIC_QR_SBP',
          'sbp.scenario' => 'C2B'
        }
      }
    end
  end
end
