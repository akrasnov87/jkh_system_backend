module MobileApi
  module Entities
    class ServiceOrders < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :subject, documentation: { type: String }
      expose :description, documentation: { type: String }
      expose :status, documentation: { type: String }
      expose :created_at, documentation: { type: DateTime }
      expose :updated_at, documentation: { type: DateTime }
      expose :address, documentation: { type: String }
      expose :attachments, using: MobileApi::Entities::Attachment
      expose :service_payments, using: MobileApi::Entities::ServicePayments, documentation: { is_array: true }
      expose :service_replies, using: MobileApi::Entities::Replies, documentation: { is_array: true }

      def service_replies
        object.service_replies.order(created_at: :desc)
      end
    end
  end
end
