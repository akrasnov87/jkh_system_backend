module Sber
  class ApiService < BaseService
    SCOPES = {
      create: 'https://api.sberbank.ru/qr/order.create',
      status: 'https://api.sberbank.ru/qr/order.status',
      revocation: 'https://api.sberbank.ru/qr/order.revoke',
      cancel: 'https://api.sberbank.ru/qr/order.cancel',
      registry: 'auth://qr/order.registry'
    }.freeze

    URLS = {
      create: 'https://mc.api.sberbank.ru:443/prod/qr/order/v3/creation',
      status: 'https://mc.api.sberbank.ru:443/prod/qr/order/v3/status',
      revocation: 'https://mc.api.sberbank.ru:443/prod/qr/order/v3/revocation',
      cancel: 'https://mc.api.sberbank.ru:443/prod/qr/order/v3/cancel',
      registry: 'https://mc.api.sberbank.ru:443/prod/qr/order/v3/registry'
    }.freeze

    def connection(event)
      token = fetch_token(event)

      return unless token

      @connection ||= Faraday.new(ssl:) do |conn|
        conn.request :json
        conn.headers[:content_type] = 'application/json'
        conn.request :authorization, :Bearer, token
        conn.headers[:accept] = '*/*'
        conn.response :json
      end
    end

    def fetch_token(event)
      response = Sber::OauthService.token_request(SCOPES[event], company)

      return unless response.status == 200

      response.body.deep_symbolize_keys[:access_token]
    end

    def registry_payments(params)
      rq_uid = SecureRandom.uuid.delete('-')
      connection(:registry).post(URLS[:registry]) do |request|
        request.headers['RqUID'] = rq_uid
        request.body = params.merge(rqUid: rq_uid).to_json
      end
    end

    def cancel_payment(params)
      rq_uid = SecureRandom.uuid.delete('-')
      connection(:cancel).post(URLS[:cancel]) do |request|
        request.headers['RqUID'] = rq_uid
        request.body = params.merge(rq_uid:).to_json
      end
    end

    def revoke_payment(params)
      rq_uid = SecureRandom.uuid.delete('-')
      connection(:revocation).post(URLS[:revocation]) do |request|
        request.headers['RqUID'] = rq_uid
        request.body = params.merge(rq_uid:).to_json
      end
    end

    def status_payment(params)
      rq_uid = SecureRandom.uuid.delete('-')
      connection(:status).post(URLS[:status]) do |request|
        request.headers['RqUID'] = rq_uid
        request.body = params.merge(rq_uid:).to_json
      end
    end

    def create_payment(params)
      connection(:create).post(URLS[:create]) do |request|
        request.headers['RqUID'] = params[:rq_uid]
        request.body = params.to_json
      end
    end
  end
end
