module Payments
  class Status
    include Helpers

    attr_reader :payment, :body

    def initialize(payment)
      @payment = payment
    end

    def call
      response = Sber::ApiService.new(payment.company).status_payment(fetch_request_params)

      if response.status != 200
        Rails.logger.debug "Save tickets error #{response.status}, #{response.body}"
        return
      end

      @body = if response.body.is_a?(Hash)
                response.body.deep_symbolize_keys
              else
                JSON.parse(response.body).deep_symbolize_keys
              end
      update_payment(@body)
      payment
    end

    def update_payment(body)
      return unless Payment.statuses.value?(SBER_STATUSES[body[:order_state]])

      payment.update!(status: SBER_STATUSES[body[:order_state]])
    end

    def fetch_request_params
      {
        rq_tm: date_format(Time.current),
        order_id: payment.order_id.to_s,
        tid: payment.id_qr,
        partner_order_number: payment.id.to_s
      }
    end
  end
end
