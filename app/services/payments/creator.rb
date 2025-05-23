module Payments
  class Creator
    include Helpers

    attr_reader :account, :order_sum, :kind, :rq_uid, :payment, :company

    MAX_RETRY = 5

    def initialize(account, params)
      @account = account
      @company = account.company
      @order_sum = params[:order_sum]
      @kind = params[:kind]
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

    def send_sber_request
      @retry_count += 1
      response = Sber::ApiService.new(company).create_payment(fetch_request_params)

      return response if response.status == 200

      Rails.logger.warn "Payment request error #{response.body} #{response.status}"
      sleep(10)
      send_sber_request if @retry_count < MAX_RETRY
    rescue StandardError => e
      Rails.logger.warn "Payment request error #{e} #{response}"
      sleep(10)
      send_sber_request if @retry_count < MAX_RETRY
    end

    def update_payment(body)
      payment.update(
        order_form_url: body[:order_form_url],
        order_id: body[:order_id]
      )
    end

    def converted_sum
      (order_sum.to_f * 100).to_i
    end

    def sbp_member_id
      return {} if kind == 'sber'

      { sbp_member_id: '100000000111' }
    end

    def fetch_request_params
      {
        rq_uid: payment.rq_uid,
        rq_tm: date_format(Time.current),
        member_id: ENV["SBER_MEMBER_ID_#{company.upcase}"],
        order_number: payment.id.to_s,
        order_create_date: date_format(payment.created_at),
        order_params_type: [
          {
            position_name: account.number.to_s,
            position_count: 1,
            position_sum: converted_sum,
            position_description: account.number.to_s
          }
        ],
        id_qr: fetch_id_qr,
        order_sum: converted_sum,
        currency: '643',
        description: "Оплата лицевого счета #{account.number}"
      }.merge(sbp_member_id)
    end
  end
end
