module MobileApi
  module Entities
    class CompanyInfos < Grape::Entity
      expose :name, documentation: { type: String, desc: 'Наименование' }

      expose :phone, documentation: { type: String, desc: 'Телефон' }
      expose :email, documentation: { type: String, desc: 'Почта' }
      expose :address, documentation: { type: String, desc: 'Адрес' }
      expose :working_schedules, documentation: { type: String, desc: 'График работы' }
      expose :emergency_phone, using: MobileApi::Entities::EmergencyPhones
      expose :attachments, using: MobileApi::Entities::Attachment

      def name
        I18n.t("companies.#{object.company}")
      end

      def emergency_phone
        EmergencyPhone.find_by(company: object.company)
      end
    end
  end
end
