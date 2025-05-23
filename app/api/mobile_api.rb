require 'grape-swagger'

module MobileApi
  class Root < Grape::API
    format :json
    prefix 'api/mobile'

    helpers ApiHelpers

    before do
      I18n.locale = :ru
      header['Access-Control-Allow-Origin'] = '*'
      header['Access-Control-Request-Method'] = '*'
    end

    mount MobileApi::V1::Root

    add_swagger_documentation info: {
      title: 'Документация к мобильному апи', add_version: false
    }
  end
end
