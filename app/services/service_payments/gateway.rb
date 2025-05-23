module ServicePayments
  class Gateway < Sber::BaseService
    def connection
      @connection ||= Faraday.new(ENV['SBER_SERVICE_GATEWAY']) do |conn|
        conn.request :json
        conn.headers[:content_type] = 'application/json'
        conn.response :json
      end
    end

    def update_password
      connection.post('https://ecommerce.sberbank.ru/ecomm/gw/partner/api/accounts/v1/set-permanent-password') do |request|
        request.body = {
          login: '',
          tmpPassword: ''
        }.to_json
      end
    end

    def decline_payment(params)
      connection.post('ecomm/gw/partner/api/v1/decline.do') do |request|
        request.headers['x-idempotencyKey'] = SecureRandom.uuid
        request.body = params.to_json
      end
    end

    def status_payment(params)
      connection.post('ecomm/gw/partner/api/v1/getOrderStatusExtended.do') do |request|
        request.headers['x-idempotencyKey'] = SecureRandom.uuid
        request.body = params.to_json
      end
    end

    def create_payment(params)
      connection.post('ecomm/gw/partner/api/v1/register.do') do |request|
        request.headers['x-idempotencyKey'] = SecureRandom.uuid
        request.body = params.to_json
      end
    end
  end
end
