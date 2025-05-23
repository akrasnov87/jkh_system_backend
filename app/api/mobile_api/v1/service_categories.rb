module MobileApi
  module V1
    class ServiceCategories < Grape::API
      resources :service_categories do
        desc 'Категории услуг', {
          is_array: true,
          entity: MobileApi::Entities::ServiceCategories
        }

        params do
          requires :company, type: String, values: ServiceCategory.companies.keys
        end

        get '/' do
          authenticate!
          if params[:company].in?(ServiceCategory.companies.keys)
            MobileApi::Entities::ServiceCategories.represent(
              ServiceCategory.send(params[:company]).order(position: :asc)
            )
          end
        end
      end
    end
  end
end
