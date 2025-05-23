module Payments
  class Cancel
    include Helpers

    attr_reader :payment

    def initialize(payment)
      @payment = payment
    end

    def call
      status_response = Status.new(payment).call.body
      last_pay_operation = status_response[:order_operation_params].find do |operation|
        operation[:operation_type] == 'PAY'
      end
      response = Sber::ApiService.new(payment.company).cancel_payment(fetch_request_params(last_pay_operation))

      return if response.status != 200

      @body = if response.body.is_a?(Hash)
                response.body.deep_symbolize_keys
              else
                JSON.parse(response.body).deep_symbolize_keys
              end
      update_payment(@body)
      payment
    end

    def converted_sum
      (payment.order_sum.to_f * 100).to_i
    end

    def update_payment(body)
      payment.update(status: SBER_STATUSES[body[:order_state]])
    end

    def fetch_request_params(last_pay_operation)
      {
        rq_tm: date_format(Time.current),
        operation_id: last_pay_operation[:operation_id],
        operation_type: 'REFUND',
        order_id: payment.order_id.to_s,
        id_qr: payment.id_qr.to_s,
        cancel_operation_sum: converted_sum,
        operation_currency: '643',
        auth_code: last_pay_operation[:auth_code],
        tid: ENV["SBER_TID_#{company.upcase}"]
      }
    end
  end
end
