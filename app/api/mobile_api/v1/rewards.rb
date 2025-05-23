module MobileApi
  module V1
    class Rewards < Grape::API
      resources :rewards do
        desc 'Награды кампании', {
          is_array: true,
          entity: MobileApi::Entities::Rewards
        }

        params do
          requires :company, type: String, values: Reward.companies.keys
        end

        get '/' do
          authenticate!
          MobileApi::Entities::Rewards.represent(Reward.send(params[:company])) if params[:company].in?(Reward.companies.keys)
        end
      end
    end
  end
end
