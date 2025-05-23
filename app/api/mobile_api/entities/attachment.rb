module MobileApi
  module Entities
    class Attachment < Grape::Entity
      expose :url, documentation: { type: String }
      expose :content_type, documentation: { type: String }
      expose :file_name, documentation: { type: String }

      def file_name
        object.file.filename.to_s
      end

      def content_type
        object.file.content_type
      end
    end
  end
end
