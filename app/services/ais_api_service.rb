class AisApiService
  class << self
    def connection
      @connection ||= Faraday.new(ENV['AIS_HOST']) do |conn|
        conn.request :json
        conn.params[:'X-API-KEY'] = ENV['AIS_KEY']
        conn.response :json
      end
    end

    def accounts_by_phone(phone, company)
      connection.get("api/#{ENV["AIS_#{company.upcase}_KEY"]}/accounts/byPhone/#{phone}")
    end

    def accounts_by_page(page, company)
      connection.get("api/#{ENV["AIS_#{company.upcase}_KEY"]}/accounts/getAll/#{page.to_i}")
    end

    def account_by_external_id(external_id, company)
      connection.get("api/#{ENV["AIS_#{company.upcase}_KEY"]}/accounts/#{external_id}")
    end

    def counters_by_account(account_id, company)
      connection.get("api/#{ENV["AIS_#{company.upcase}_KEY"]}/counters/byAccountId/#{account_id}")
    end

    def charges_by_account_and_month(account_id, year, month, company)
      connection.get("api/#{ENV["AIS_#{company.upcase}_KEY"]}/charges/byAccountId/#{account_id}/#{year}/#{month}")
    end

    def charges_by_account_and_year(account_id, year, company)
      connection.get("api/#{ENV["AIS_#{company.upcase}_KEY"]}/charges/byAccountId/#{account_id}/#{year}")
    end

    def counters_values_last(counter_id, company)
      connection.get("api/#{ENV["AIS_#{company.upcase}_KEY"]}/countersValues/byCounterId/#{counter_id}/last")
    end

    def counters_values_by_year(counter_id, year, company)
      connection.get("api/#{ENV["AIS_#{company.upcase}_KEY"]}/countersValues/byCounterId/#{counter_id}/#{year}")
    end

    def send_counter_value(counter_id, company, value)
      connection.get(
        "api/#{ENV["AIS_#{company.upcase}_KEY"]}/countersValues/add/#{counter_id}?val=#{value.val}&periodYear=#{value.year}&periodMonth=#{value.month}"
      )
    end

    def current_total_sum_by_account(account, month)
      connection.get("api/#{ENV["AIS_#{account.company.upcase}_KEY"]}/totalSum/byAccountId/#{account.external_id}/#{Date.current.year}/#{month}")
    end
  end
end
