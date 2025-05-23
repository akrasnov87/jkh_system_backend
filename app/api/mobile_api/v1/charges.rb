module MobileApi
  module V1
    class Charges < Grape::API
      resources :charges do
        desc 'Список расходов по лицевому счету за месяц', {
          is_array: true,
          entity: MobileApi::Entities::Charges
        }
        params do
          requires :account_id, type: String
          requires :year, type: Integer
          requires :month, type: Integer
        end
        get '/by_month' do
          authenticate!
          charges = current_user.accounts.find_by(id: params[:account_id])
                                 .charges.where(year: params[:year], month: params[:month])
          charges = AisImporter::Charges.new(params[:account_id]).by_account_and_month(params[:year], params[:month]) if charges.empty?

          MobileApi::Entities::Charges.represent(charges)
        end

        desc 'Список расходов по лицевому счету за год'
        params do
          requires :account_id, type: String
          requires :year, type: Integer
        end

        get '/by_year' do
          authenticate!
          charges = current_user.accounts.find_by(id: params[:account_id])
                                .charges.where(year: params[:year])
          if Time.zone.today.prev_month.month != charges.group(:month).count.keys.last
            charges = AisImporter::Charges.new(params[:account_id]).charges_by_account_and_year(params[:year])
          end

          result = charges.each_with_object({}) do |charge, memo|
            memo[charge.month] = (memo[charge.month].to_f + charge.sum_nach_all.to_f).round(2)
            memo
          end
          result
        end
      end
    end
  end
end
