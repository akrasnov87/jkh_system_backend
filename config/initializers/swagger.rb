GrapeSwaggerRails.options.url = '/api/mobile/swagger_doc.json'
GrapeSwaggerRails.options.app_url = if Rails.env.development?
                                      'http://localhost:3000'
                                    else
                                      'https://jkh-system.ru'
                                    end

GrapeSwaggerRails.options.app_name = 'Swagger'
GrapeSwaggerRails.options.doc_expansion = 'list'
GrapeSwaggerRails.options.api_auth     = 'bearer'
GrapeSwaggerRails.options.api_key_name = 'Authorization'
GrapeSwaggerRails.options.api_key_type = 'header'
