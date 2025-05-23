module MobileApi
  module V1
    class CompanyPhones < Grape::API
      resources :company_phones do
        desc 'Список компаний с телефонами', {
          is_array: true,
          entity: MobileApi::Entities::CompanyPhones
        }

        get '/' do
          authenticate!
          MobileApi::Entities::CompanyPhones.represent(CompanyPhone.all)
        end
      end
    end
  end
end
