module MobileApi
  module V1
    class ServiceWorks < Grape::API
      resources :service_works do
        desc 'Категории услуг', {
          is_array: true,
          entity: MobileApi::Entities::ServiceWorks
        }

        params do
          requires :service_category_id, type: Integer
        end

        get '/' do
          authenticate!
          MobileApi::Entities::ServiceWorks.represent(
            ServiceWork.where(service_category_id: params[:service_category_id]).order(position: :asc)
          )
        end
      end
    end
  end
end
