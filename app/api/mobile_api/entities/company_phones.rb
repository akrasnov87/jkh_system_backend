module MobileApi
  module Entities
    class CompanyPhones < Grape::Entity
      expose :name, documentation: { type: String }
      expose :number, documentation: { type: String }
    end
  end
end
