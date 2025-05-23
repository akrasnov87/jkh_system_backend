module MobileApi
  module Entities
    class ServiceWorks < Grape::Entity
      expose :id, documentation: { type: Integer, desc: 'id' }
      expose :name, documentation: { type: String, desc: 'Имя' }
      expose :company, documentation: { type: String, desc: 'Компания' }
    end
  end
end
