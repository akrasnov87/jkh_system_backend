module MobileApi
  module V1
    class Pushes < Grape::API
      resources :pushes do
        desc 'Пуши собственника', {
          entity: MobileApi::Entities::Pushes
        }

        params do
          optional :type, type: String, values: %w(count)
        end

        get '/' do
          authenticate!
          if params[:type]
            pushes = current_user.pushes.where(is_new: true).limit(10)
            { count: pushes.count }
          else
            pushes = current_user.pushes.order(created_at: :desc).limit(10)
            current_user.pushes.update(is_new: false)
            MobileApi::Entities::Pushes.represent(pushes)
          end
        end
      end
    end
  end
end
