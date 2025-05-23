module Sber
  class OauthService < BaseService
    def self.token_request(scope, company)
      new(company).token_request(scope)
    end

    def connection
      @connection ||= Faraday.new(ssl:) do |conn|
        conn.request :json
        conn.headers[:RqUID] = SecureRandom.uuid.delete('-')
        conn.request :authorization, :basic,
                     ENV["SBER_CLIENT_ID_#{company.upcase}"],
                     ENV["SBER_SECRET_#{company.upcase}"]
        conn.headers[:content_type] = 'application/x-www-form-urlencoded'
        conn.headers[:accept] = '*/*'
        conn.response :json
      end
    end

    def token_request(scope)
      connection.post(url) do |req|
        req.body = "grant_type=client_credentials&scope=#{scope}"
      end
    end

    def url
      'https://mc.api.sberbank.ru:443/prod/tokens/v3/oauth'
    end
  end
end
