module GatewayPayments
  class Status
    include Helpers

    attr_reader :payment, :body, :company

    def initialize(payment)
      @payment = payment
      @company = payment.company
    end

    def call
      response = Sber::Gateway.new(company).status_payment(fetch_request_params)

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
      if body[:orderStatus] == 2
        payment.paid!
      elsif body[:orderStatus] == 6
        payment.revoked!
      end
    end

    def fetch_request_params
      {
        userName: fetch_user_name,
        password: fetch_user_password,
        orderId: payment.order_id.to_s
      }
    end
  end
end
