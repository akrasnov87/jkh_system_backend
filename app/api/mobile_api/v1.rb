module MobileApi
  module V1
    class Root < Grape::API
      VERSION = '1'.freeze
      version VERSION, using: :path

      rescue_from ActiveRecord::RecordNotFound do |_e|
        error!('not found', 404)
      end

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        errors = e.each_with_object({}) do |er, res|
          er[0].each do |a|
            res[a] = [] unless res[a]
            res[a] << er[1].to_s
          end
        end
        error!({ errors: }, 400)
      end

      unless Rails.env.development?
        rescue_from :all do |_e|
          error!('System error', 500)
        end
      end

      mount MobileApi::V1::Sessions
      mount MobileApi::V1::Usrs
      mount MobileApi::V1::Accounts
      mount MobileApi::V1::Counters
      mount MobileApi::V1::Payments
      mount MobileApi::V1::Tickets
      mount MobileApi::V1::Charges
      mount MobileApi::V1::CompanyPhones
      mount MobileApi::V1::Tariffs
      mount MobileApi::V1::CompanyDetails
      mount MobileApi::V1::UserPushTokens
      mount MobileApi::V1::Pushes
      mount MobileApi::V1::Notifications
      mount MobileApi::V1::EmergencyPhones
      mount MobileApi::V1::CompanyInfos
      mount MobileApi::V1::Rewards
      mount MobileApi::V1::UsefulContacts
      mount MobileApi::V1::Versions
      mount MobileApi::V1::ServiceCategories
      mount MobileApi::V1::ServiceWorks
      mount MobileApi::V1::ServiceOrders
    end
  end
end
