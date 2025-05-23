module MobileApi
  module Entities
    class Tariffs < Grape::Entity
      expose :name, documentation: { type: String }
      expose :explanation, documentation: { type: String }
    end
  end
end
