module MobileApi
  module V1
    class CompanyDetails < Grape::API
      resources :company_details do
        desc 'Реквизиты компании', {
          entity: MobileApi::Entities::CompanyDetails
        }

        params do
          requires :company, type: String, values: CompanyDetail.companies.keys
        end

        get '/' do
          authenticate!
          if params[:company].in?(CompanyDetail.companies.keys)
            MobileApi::Entities::CompanyDetails.represent(CompanyDetail.send(params[:company]).last)
          end
        end
      end
    end
  end
end
