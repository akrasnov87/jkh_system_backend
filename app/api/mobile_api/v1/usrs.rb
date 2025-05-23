module MobileApi
  module V1
    class Usrs < Grape::API
      resources :users do
        desc 'Обновление профиля', { entity: MobileApi::Entities::User }
        params do
          requires :user, type: Hash do
            optional :send_push_notifications, type: 'Boolean'
          end
        end
        put '/' do
          authenticate!
          if current_user.update(send_push_notifications: params[:user][:send_push_notifications])
            MobileApi::Entities::User.represent(current_user)
          else
            active_error!(:user, current_user)
          end
        end

        desc 'Удалить профиль', { entity: MobileApi::Entities::User }
        params do
          requires :user_id, type: String
        end
        delete '/' do
          authenticate!
          User.find(params[:user_id]).destroy
          'ok'
        end

        desc 'Получение профиля', { entity: MobileApi::Entities::User }
        get '/profile' do
          authenticate!
          MobileApi::Entities::User.represent(current_user)
        end
      end
    end
  end
end
