module MobileApi
  module Entities
    class CounterValue < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :year, documentation: { type: Integer }
      expose :month, documentation: { type: Integer }
      expose :val, documentation: { type: Float }
    end
  end
end
