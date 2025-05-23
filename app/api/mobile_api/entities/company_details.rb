module MobileApi
  module Entities
    class CompanyDetails < Grape::Entity
      expose :name, documentation: { type: String, desc: 'Наименование' }
      expose :address, documentation: { type: String, desc: 'Юридический адрес' }
      expose :inn, documentation: { type: String, desc: 'ИНН' }
      expose :kpp, documentation: { type: String, desc: 'КПП' }
      expose :bill_type, documentation: { type: String, desc: 'Название счета' }
      expose :bill_number, documentation: { type: String, desc: 'р/с' }
      expose :bank_name, documentation: { type: String, desc: 'Банк' }
      expose :bik, documentation: { type: String, desc: 'БИК' }
      expose :bill_cor, documentation: { type: String, desc: 'к/с' }
    end
  end
end
