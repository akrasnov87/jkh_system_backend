module MobileApi
  module V1
    class UserPushTokens < Grape::API
      resource :user_push_tokens do
        desc 'Регистрация пуш токена'
        params do
          requires :user_push_token, type: Hash do
            requires :token, type: String, desc: 'PushToken строка'
          end
        end
        post '/' do
          authenticate!
          user_push_token = current_user.push_tokens.find_or_initialize_by(device_id: current_token.device_id)
          if user_push_token.update(token: params[:user_push_token][:token])
            { result: 'ok' }
          else
            active_error!(:user_push_token, user_push_token)
          end
        end

        desc 'Удаление пуш токена'
        params do
          requires :user_push_token, type: Hash do
            requires :token, type: String, desc: 'PushToken строка'
          end
        end
        delete '/' do
          authenticate!
          user_push_token = current_user.push_tokens.find_by(token: params[:user_push_token][:token])
          if user_push_token&.destroy
            { result: 'ok' }
          else
            error!({ errors: { 'token' => 'Неверный токен' } }, 400)
          end
        end
      end
    end
  end
end
