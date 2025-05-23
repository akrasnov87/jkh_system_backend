module MobileApi
  module Entities
    class Rewards < Grape::Entity
      expose :title, documentation: { type: String, desc: 'Заголовок' }
      expose :body, documentation: { type: String, desc: 'Текст' }
      expose :company, documentation: { type: String, desc: 'Компания' }
      expose :attachments, using: MobileApi::Entities::Attachment
    end
  end
end
