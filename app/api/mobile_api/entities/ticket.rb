module MobileApi
  module Entities
    class Ticket < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :user, using: MobileApi::Entities::User
      expose :account_id, documentation: { type: Integer }
      expose :subject, documentation: { type: String }
      expose :status, documentation: { type: String }
      expose :description, documentation: { type: String }
      expose :replies, using: MobileApi::Entities::Replies
      expose :created_at, documentation: { type: DateTime }
      expose :updated_at, documentation: { type: DateTime }
      expose :attachments, using: MobileApi::Entities::Attachment
      expose :address, documentation: { type: String }

      def address
        object.account.address
      end

      def replies
        object.replies.order(created_at: :desc)
      end
    end
  end
end
