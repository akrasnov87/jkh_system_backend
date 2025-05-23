module MobileApi
  module Entities
    class Replies < Grape::Entity
      expose :id, documentation: { type: Integer }
      expose :description, documentation: { type: String }
      expose :user, using: MobileApi::Entities::User
      expose :kind, documentation: { type: String }
      expose :created_at, documentation: { type: DateTime }
      expose :updated_at, documentation: { type: DateTime }
      expose :attachments, using: MobileApi::Entities::Attachment
    end
  end
end
