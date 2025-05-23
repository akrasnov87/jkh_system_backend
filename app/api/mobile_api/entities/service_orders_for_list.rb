module MobileApi
  module Entities
    class ServiceOrdersForList < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :subject, documentation: { type: String }
      expose :description, documentation: { type: String }
      expose :status, documentation: { type: String }
      expose :created_at, documentation: { type: DateTime }
      expose :updated_at, documentation: { type: DateTime }
      expose :address, documentation: { type: String }
      expose :service_payments, using: MobileApi::Entities::ServicePayments, documentation: { is_array: true }
    end
  end
end
