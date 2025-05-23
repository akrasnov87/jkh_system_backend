module MobileApi
  module Entities
    class Counter < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :counter_name, documentation: { type: String }
      expose :label, documentation: { type: String }
      expose :serial_code, documentation: { type: String }
      expose :service_name, documentation: { type: String }
      expose :service_group, documentation: { type: String }
      expose :last_check, documentation: { type: DateTime }
      expose :next_check, documentation: { type: DateTime }
      expose :counters_values, using: MobileApi::Entities::CounterValue, documentation: { is_array: true }

      def counters_values
        object.counters_values.where(year: options[:year])
      end

      def next_check
        nil
      end
    end
  end
end
