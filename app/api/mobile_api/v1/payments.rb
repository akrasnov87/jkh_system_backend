module MobileApi
  module V1
    class Payments < Grape::API
      resources :payments do
        desc 'Кнопка Оплатить'
        params do
          requires :account_id, type: Integer
          requires :order_sum, type: String
          requires :kind, type: String, values: %w(sber sbp)
        end

        post '/' do
          authenticate!
          account = current_user.accounts.find_by(id: params[:account_id])
          if account
            payment = if Account::SBP_COMPANY_PAYMENT.include?(account.company)
                        ::Payments::Creator.new(account, params).call
                      else
                        ::GatewayPayments::Creator.new(account, params).call
                      end
            ::Payments::UpdateStatusWorker.perform_at((Time.current + 2.minutes).to_i, payment.id)
            MobileApi::Entities::Payment.represent(payment)
          else
            error!({ errors: { 'account[number]' => ['Неверный лицевой счет'] } }, 406)
          end
        end
      end
    end
  end
end
