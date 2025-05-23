module MobileApi
  module V1
    class Versions < Grape::API
      resources :versions do
        desc 'Требуется обновление или нет ', {
          actual: String
        }

        params do
          requires :devise_type, type: String, values: %w(iphone android)
          requires :version, type: String
        end

        get '/' do
          authenticate!
          actual_versions = { iphone: ['2.0.8'], android: ['2.0.8'] }
          actual = actual_versions[params[:devise_type].to_sym].include?(params[:version])
          { actual: }
        end
      end
    end
  end
end
