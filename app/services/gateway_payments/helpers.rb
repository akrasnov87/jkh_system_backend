module GatewayPayments
  module Helpers
    def date_format(datetime)
      "#{datetime.strftime('%Y-%m-%dT%H:%M:%S')}"
    end

    def fetch_id_qr
      ENV["SBER_TID_#{company.upcase}"]
    end

    def fetch_user_name
      ENV["SBER_USER_#{company.upcase}"]
    end

    def fetch_user_password
      ENV["SBER_PASSWORD_#{company.upcase}"]
    end
  end
end
