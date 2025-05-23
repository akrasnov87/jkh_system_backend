module MobileApi
  module Entities
    class ServiceCategories < Grape::Entity
      expose :id, documentation: { type: Integer, desc: 'id' }
      expose :name, documentation: { type: String, desc: 'Имя' }
      expose :image, documentation: { type: String, desc: 'Картинка' }
      expose :company, documentation: { type: String, desc: 'Компания' }
    end
  end
end
