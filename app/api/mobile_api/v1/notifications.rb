module MobileApi
  module V1
    class Notifications < Grape::API
      resources :notifications do
        desc 'Объявления', {
          entity: MobileApi::Entities::Notifications
        }

        params do
          requires :kind, type: String, values: Notification.kinds.keys
          optional :account_id, type: Integer
        end

        get '/' do
          authenticate!
          if params[:kind].in?(Notification.kinds.keys)
            account = Account.find(params[:account_id]) if params[:account_id].present?

            notifications = case params[:kind]
                            when 'general'
                              Notification.general.active
                                          .includes(
                                            icons: { file_attachment: :blob },
                                            news_images: { file_attachment: :blob }
                                          )
                            when 'personal_company'
                              Notification.personal_company.active.where(company: account.company).last
                            when 'personal_house'
                              Notification.personal_house.active.where(house: account.house).last
                            end
            MobileApi::Entities::Notifications.represent(notifications)
          end
        end
      end
    end
  end
end
