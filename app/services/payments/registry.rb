module Payments
  class Registry
    include Helpers
    attr_reader :kind, :body, :status, :company

    def initialize(type, company)
      @kind = type
      @company = company
    end

    def call
      response = Sber::ApiService.new(company).registry_payments(fetch_request_params)

      @body = if response.body.is_a?(Hash)
                response.body.deep_symbolize_keys
              else
                JSON.parse(response.body).deep_symbolize_keys
              end
      @status = response.status
      self
    end

    def fetch_request_params
      {
        "rqTm": date_format(Time.current),
        "idQR": fetch_id_qr,
        "startPeriod": date_format(Time.current.beginning_of_day),
        "endPeriod": date_format(Time.current.end_of_day),
        "registryType": 'REGISTRY'
      }
    end
  end
end
