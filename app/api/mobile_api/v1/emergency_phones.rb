module MobileApi
  module V1
    class EmergencyPhones < Grape::API
      resources :emergency_phones do
        desc 'Список аварийных номеров телефонов', {
          is_array: true,
          entity: MobileApi::Entities::EmergencyPhones
        }

        get '/' do
          authenticate!
          MobileApi::Entities::EmergencyPhones.represent(EmergencyPhone.all)
        end
      end
    end
  end
end
