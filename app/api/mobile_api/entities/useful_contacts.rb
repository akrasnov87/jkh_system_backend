module MobileApi
  module Entities
    class UsefulContacts < Grape::Entity
      expose :name, documentation: { type: String, desc: 'Название' }
      expose :number, documentation: { type: String, desc: 'Номер' }
      expose :company, documentation: { type: String, desc: 'Компания' }
    end
  end
end
