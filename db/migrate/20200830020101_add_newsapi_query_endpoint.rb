class AddNewsapiQueryEndpoint < ActiveRecord::Migration[5.2]
  def change
    Endpoint.new(name: 'get_all_news',
                 url_path: '/v2/everything',
                 params: {q: {type:'String', optional: false},
                          qInTitle: {type: 'String', optional: true},
                          sources: {type: 'String', optional: true},
                          domains: {type: 'String', optional: true},
                          excludeDomains: {type: 'String', optional: true},
                          from: {type: 'Date', optional: true},
                          to: {type: 'Date', optional: true},
                          language: {type: 'String', optional: true},
                          sortBy: {type: 'String', optional: true}},
                    client_tag: 'newsapi',
                    request_method: 'get',
                    body_template: nil).save!
  end
end
