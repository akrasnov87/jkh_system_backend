module MobileApi
  module Entities
    class TicketForList < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :subject, documentation: { type: String }
      expose :description, documentation: { type: String }
      expose :status, documentation: { type: String }
      expose :created_at, documentation: { type: DateTime }
      expose :updated_at, documentation: { type: DateTime }
      expose :address, documentation: { type: String }

      def address
        object.account.address
      end
    end
  end
end
