module MobileApi
  module V1
    class UsefulContacts < Grape::API
      resources :useful_contacts do
        desc 'Полезные контакты', {
          is_array: true,
          entity: MobileApi::Entities::UsefulContacts
        }

        params do
          requires :company, type: String, values: UsefulContact.companies.keys
        end

        get '/' do
          authenticate!
          MobileApi::Entities::UsefulContacts.represent(UsefulContact.send(params[:company])) if params[:company].in?(UsefulContact.companies.keys)
        end
      end
    end
  end
end
