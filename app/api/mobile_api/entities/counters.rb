module MobileApi
  module Entities
    class Counters < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :counter_name, documentation: { type: String }
      expose :label, documentation: { type: String }
      expose :serial_code, documentation: { type: String }
      expose :service_name, documentation: { type: String }
      expose :service_group, documentation: { type: String }
      expose :last_check, documentation: { type: DateTime }
      expose :next_check, documentation: { type: DateTime }

      def next_check
        nil
      end
    end
  end
end
