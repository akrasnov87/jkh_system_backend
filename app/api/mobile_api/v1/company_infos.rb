module MobileApi
  module V1
    class CompanyInfos < Grape::API
      resources :company_infos do
        desc 'Информация о кампании', {
          entity: MobileApi::Entities::CompanyInfos
        }

        params do
          requires :company, type: String, values: CompanyInfo.companies.keys
        end

        get '/' do
          authenticate!
          MobileApi::Entities::CompanyInfos.represent(CompanyInfo.send(params[:company]).last) if params[:company].in?(CompanyInfo.companies.keys)
        end
      end
    end
  end
end
