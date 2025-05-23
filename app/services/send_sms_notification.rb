class SendSmsNotification
  class << self
    def connection
      @connection ||= Faraday.new('https://api.bytehand.com/') do |conn|
        conn.headers[:content_type] = 'application/json;charset=UTF-8'
        conn.headers[:accept] = '*/*'
        conn.headers['X-Service-Key'] = ENV['BYTEHAND_API_KEY']
        conn.request :json
        conn.response :json
      end
    end

    def call(phone, sms_code)
      phone = Phone.new(phone).to_sms
      sms_counter = Red.get(phone).to_i
      Red.setex(phone, 24.hours.to_i, (sms_counter + 1).to_s)
      return if sms_counter > 2

      connection.post('v2/sms/messages') do |request|
        request.body = {
          'sender': ENV['BYTEHAND_SENDER'],
          'receiver': phone,
          'text': "Код для авторизации в ЖКХ Системе: #{sms_code}"
        }.to_json
      end
    end
  end
end
