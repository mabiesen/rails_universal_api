class AddNewsapiSourcesEndpoint < ActiveRecord::Migration[5.2]
  def change
    Endpoint.new(name: 'get_all_sources',
                 url_path: '/v2/sources',
                 params: {category: {type:'String', optional: true},
                          language: {type: 'Date', optional: true},
                          country: {type: 'Date', optional: true}},
                    client_tag: 'newsapi',
                    request_method: 'get',
                    body_template: nil).save!
  end
end
