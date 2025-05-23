module MobileApi
  module Entities
    class Pushes < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :title, documentation: { type: String }
      expose :body, documentation: { type: String }
      expose :created_at, documentation: { type: String }
      expose :data, documentation: { type: Hash }

      def created_at
        object.created_at.strftime('%d.%m.%Y в %H:%M')
      end
    end
  end
end
