module Payments
  module Helpers
    SBER_STATUSES = { 'CREATED' => 0,
                      'PAID' => 1,
                      'REVERSED' => 2,
                      'REFUNDED' => 3,
                      'REVOKED' => 4,
                      'DECLINED' => 5,
                      'EXPIRED' => 6,
                      'AUTHORIZED' => 7,
                      'CONFIRMED' => 8,
                      'ON_PAYMENT' => 9 }.freeze

    def date_format(datetime)
      "#{datetime.strftime('%Y-%m-%dT%H:%M:%S')}Z"
    end

    def export_data(date)
      date.strftime('%d-%m-%Y')
    end

    def export_time(time)
      time.strftime('%H-%M-%S')
    end

    def fetch_id_qr
      ENV["SBER_TID_#{company.upcase}"]
    end
  end
end
