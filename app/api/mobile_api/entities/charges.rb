module MobileApi
  module Entities
    class Charges < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :year, documentation: { type: Integer }
      expose :month, documentation: { type: Integer }
      expose :service_name, documentation: { type: String }
      expose :tariff, documentation: { type: String }
      expose :unit, documentation: { type: String }
      expose :norm, documentation: { type: String }
      expose :norm_unit, documentation: { type: String }
      expose :sum_nach, documentation: { type: String }
      expose :sum_recalc, documentation: { type: String }
      expose :sum_nach_all, documentation: { type: String }
      expose :consume, documentation: { type: String }
    end
  end
end
