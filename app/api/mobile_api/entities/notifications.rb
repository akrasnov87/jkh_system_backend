module MobileApi
  module Entities
    class Notifications < Grape::Entity
      expose :image, documentation: { type: String, desc: 'Картинка' }
      expose :title, documentation: { type: String, desc: 'Заголовок' }
      expose :body, documentation: { type: String, desc: 'Сообщение' }
      expose :kind, documentation: { type: String, desc: 'Тип сообщения' }
      expose :url_action, documentation: { type: String, desc: 'Страничка для перенаправления' }
      expose :attachments, using: MobileApi::Entities::Attachment
      expose :icons, using: MobileApi::Entities::Attachment

      def icons
        object.icons
      end

      def attachments
        object.news_images
      end
    end
  end
end
