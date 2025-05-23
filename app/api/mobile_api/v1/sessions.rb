module MobileApi
  module V1
    class Sessions < Grape::API
      resources :sessions do # rubocop:disable Metrics/BlockLength
        resources :email do
          desc 'Логин по email'
          params do
            requires :user, type: Hash do
              requires :email, type: String
              requires :password, type: String
            end
            requires :device_type, type: String, values: %w(iphone android)
            requires :device_id, type: String
          end
          post '/' do
            user = User.find_for_database_authentication(email: params[:user][:email])
            if user.present? && user.valid_password?(params[:user][:password])
              token = user.recreate_api_token(params[:device_id], params[:device_type])
              { api_token: token.token, user: MobileApi::Entities::User.represent(user) }
            else
              error!({ errors: { 'user[email]' => ['Неверный email или пароль'] } }, 401)
            end
          end
        end
        resources :phone do # rubocop:disable Metrics/BlockLength
          desc 'Запрос на отсылку смс, отдает время следующей возможной отсылки'
          params do
            requires :user, type: Hash do
              requires :phone, type: String
            end
          end
          get '/new' do
            phone = Phone.new(params[:user][:phone])
            if phone.valid?
              user = UserBuilder.new(phone.number).perform
              user.recreate_sms_code
              expire_at = User::SMS_CODE_TIMEOUT.minutes.since(user.sms_code_sended_at)
              {
                "expire_at": expire_at,
                "number": phone.number
              }
            else
              error!({ errors: { 'user[phone]' => ['Неверный телефон'] } }, 401)
            end
          end

          desc 'Логин по смс коду'
          params do
            requires :user, type: Hash do
              requires :phone, type: String
            end
            requires :device_type, type: String, values: %w(iphone android)
            requires :device_id, type: String
            requires :code, type: String
          end
          post '/' do
            phone = params[:user][:phone]
            user = User.find_by(phone:)
            if user
              if user.valid_sms_code?(params[:code])
                user.consume_sms_code
                token = user.recreate_api_token(params[:device_id], params[:device_type])
                { api_token: token.token, user: MobileApi::Entities::User.represent(user) }
              else
                user.increment!(:sms_code_failed_attempts)
                if user.sms_code_failed_attempts.to_i >= User::SMS_CODE_MAX_ATTEMPTS
                  error!({ errors: { 'code' => ['Неверный код, не осталось попыток'] } }, 401)
                else
                  error!(
                    { errors: { 'code' => [
                      "Неверный код, осталось попыток #{user.sms_code_remained_attempts}"
                    ] } }, 401
                  )
                end
              end
            else
              error!({ errors: { 'user[phone]' => ['Неверный телефон'] } }, 401)
            end
          end
        end

        desc 'Логаут'
        delete '/' do
          authenticate!
          current_token.destroy
          'ok'
        end
      end
    end
  end
end
