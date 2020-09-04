class AddGithubPullRequestEndpoint < ActiveRecord::Migration[5.2]
  def up
    Endpoint.new(name: 'get_current_weather',
                 url_path: '/v1/current.json',
                 params: {q: {type:'String', optional: false},
                          days: {type:'Integer', optional: true},
                          dt: {type: 'Date', optional: true},
                          unixdt: {type: 'Integer', optional: true},
                          end_dt: {type: 'Date', optional: true},
                          unixend_dt: {type: 'Integer', optional: true},
                          hour: {type: 'Integer', optional: true},
                          lang: {type: 'String', optional: true}},
                    client_tag: 'weatherapi',
                    request_method: 'get',
                    body_template: nil).save!
  end

  def down
    Endpoint.where(name: 'get_pull_requests')
            .where(client_tag: 'github').first.try(:destroy)
  end
end
