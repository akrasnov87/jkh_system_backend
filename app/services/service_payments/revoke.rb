module ServicePayments
  class Revoke
    include Helpers

    attr_reader :service_payment

    def initialize(service_payment)
      @service_payment = service_payment
    end

    def call
      response = ServicePayments::Gateway.new.decline_payment(fetch_request_params)

      if response.status != 200
        Rails.logger.warn "Revoke payments error #{response.status}, #{response.body}"
        return
      end

      @body = if response.body.is_a?(Hash)
                response.body.deep_symbolize_keys
              else
                JSON.parse(response.body).deep_symbolize_keys
              end
      update_service_payment(@body)
      service_payment
    end

    def fetch_request_params
      {
        userName: fetch_user_name,
        password: fetch_user_password,
        orderId: service_payment.order_id.to_s
      }
    end

    def update_service_payment(body)
      return unless body[:errorCode] == 0

      service_payment.revoked!
    end
  end
end
