module MobileApi
  module Entities
    class Payment < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :status, documentation: { type: String }
      expose :order_form_url, documentation: { type: String }
    end
  end
end
