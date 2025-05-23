module MobileApi
  module V1
    class Accounts < Grape::API
      resources :accounts do # rubocop:disable Metrics/BlockLength
        desc 'Список собственных ЛС', {
          is_array: true,
          entity: MobileApi::Entities::Account
        }
        get '/' do
          authenticate!
          unless Red.exists?("user_id-#{current_user.id}")
            Red.setex("user_id-#{current_user.id}", 24.hours.to_i, 'true')
            Account.where('phone like ?', "%#{Phone.new(current_user.phone).to_account}%").find_each do |account|
              ::AddedAccountToUser.new(current_user, account).call
            end
            ::Accounts::ImportSumToPayWorker.perform_async(current_user.id)
          end
          MobileApi::Entities::Account.represent(current_user.accounts.active, user: current_user)
        end

        desc 'Обновить account label'
        params do
          requires :label, type: String
        end
        put '/:id' do
          authenticate!
          current_user.accounts.find_by(id: params[:id])
                      .account_users.where(user_id: current_user.id)
                      .last.update(label: params[:label])
          MobileApi::Entities::Account.represent(current_user.accounts.active, user: current_user)
        end

        # desc 'Добавление лицевого счета'
        # params do
        #   requires :number, type: String
        # end
        # post '/' do
        #   authenticate!
        #   account = Account.active.find_by(number: params[:number])
        #   if account.present?
        #     ::Accounts::ImportByExternalIdWorker.perform_async(account.external_id, account.company)
        #     service = ::AddedAccountToUser.new(current_user, account).call
        #     if service.errors.empty?
        #       MobileApi::Entities::Account.represent(current_user.accounts.active, user: current_user)
        #     else
        #       error!(service.errors, 406)
        #     end
        #   else
        #     error!({ errors: { 'account[number]' => ['Неверный лицевой счет'] } }, 406)
        #   end
        # end

        desc 'Получить сумму к оплате'
        params do
          requires :account_id, type: String
        end
        get '/sum_to_pay' do
          authenticate!
          account = current_user.accounts.find_by(id: params[:account_id])
          if account.present?
            order = Order.find_by(month: Date.current.month, year: Date.current.year, account_id: account.id) ||
                    AisImporter::Orders.new(account).call
            sum_to_pay = order.sum_to_pay
            date_count = order.actual_payment ? 1 : 10
            paid_sum = ::Payment.paid.where(
              account_id: account.id, created_at: date_count.days.ago.beginning_of_day..Time.current
            ).map { |p| p.order_sum.to_f }.sum
            sum_to_pay = (sum_to_pay.to_f - paid_sum).round(2) if paid_sum > 0 && sum_to_pay.to_f >= 0

            sum_to_pay = nil if sum_to_pay.to_i == 0

            { sum_to_pay: }
          else
            error!({ errors: { 'account[account_id]' => ['Неверный лицевой счет'] } }, 406)
          end
        end

        desc 'Убрать лицевой счет'
        params do
          requires :account_id, type: String
        end
        delete '/' do
          authenticate!
          current_user.account_users.find_by(account_id: params[:account_id]).destroy
          MobileApi::Entities::Account.represent(current_user.accounts.active, user: current_user)
        end
      end
    end
  end
end
