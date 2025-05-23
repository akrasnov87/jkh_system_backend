module ServicePayments
  module Helpers
    def date_format(datetime)
      "#{datetime.strftime('%Y-%m-%dT%H:%M:%S')}"
    end

    def fetch_id_qr
      ENV['SBER_TID_SERVICE_COMPANY']
    end

    def fetch_user_name
      ENV['SBER_USER_SERVICE_COMPANY']
    end

    def fetch_user_password
      ENV['SBER_PASSWORD_SERVICE_COMPANY']
    end
  end
end
