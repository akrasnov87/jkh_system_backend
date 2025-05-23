module MobileApi
  module Entities
    class EmergencyPhones < Grape::Entity
      expose :company, documentation: { type: String }
      expose :number, documentation: { type: String }
    end
  end
end
