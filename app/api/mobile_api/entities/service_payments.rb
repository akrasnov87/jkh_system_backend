module MobileApi
  module Entities
    class ServicePayments < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :status, documentation: { type: String }
      expose :order_form_url, documentation: { type: String }
      expose :order_sum, documentation: { type: String }
    end
  end
end
