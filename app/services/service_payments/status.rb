module ServicePayments
  class Status
    include Helpers

    attr_reader :service_payment, :body

    def initialize(service_payment)
      @service_payment = service_payment
    end

    def call
      response = ServicePayments::Gateway.new.status_payment(fetch_request_params)

      if response.status != 200
        Rails.logger.warn "Status payments error #{response.status}, #{response.body}"
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

    def update_service_payment(body)
      if body[:orderStatus] == 2
        service_payment.paid!
      elsif body[:orderStatus] == 6
        service_payment.revoked!
      end

      service_order_status
    end

    def service_order_status
      service_order = service_payment.service_order
      return unless service_order.service_payments.all?(&:paid?)

      service_order.paid!
    end

    def fetch_request_params
      {
        userName: fetch_user_name,
        password: fetch_user_password,
        orderId: service_payment.order_id.to_s
      }
    end
  end
end
