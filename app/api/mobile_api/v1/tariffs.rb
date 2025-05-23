module MobileApi
  module V1
    class Tariffs < Grape::API
      resources :tariffs do
        desc 'Список тарифов по компании', {
          is_array: true,
          entity: MobileApi::Entities::Tariffs
        }

        params do
          requires :company, type: String, values: Tariff.companies.keys
        end

        get '/' do
          authenticate!
          MobileApi::Entities::Tariffs.represent(Tariff.send(params[:company]).all) if params[:company].in?(Tariff.companies.keys)
        end
      end
    end
  end
end
