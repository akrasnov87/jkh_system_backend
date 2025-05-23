module MobileApi
  module Entities
    class Account < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :number, documentation: { type: String }
      expose :label, documentation: { type: String }
      expose :date_begin, documentation: { type: DateTime }
      expose :date_end, documentation: { type: DateTime }
      expose :address, documentation: { type: String }
      expose :full_name, documentation: { type: String }
      expose :company, documentation: { type: String }
      expose :apart_name, documentation: { type: String }
      expose :apart_name_ext, documentation: { type: String }

      def number
        object.number.to_i
      end

      def label
        object.account_users.where(user_id: options[:user].id).last.label
      end
    end
  end
end
