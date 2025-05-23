module MobileApi
  module Entities
    class User < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :full_name, documentation: { type: String }
      expose :phone, documentation: { type: String }
      expose :email, documentation: { type: String }
      expose :send_push_notifications, documentation: { type: 'Boolean' }

      def full_name
        object.accounts.active.first.full_name if object.accounts.active.any?
      end
    end
  end
end
