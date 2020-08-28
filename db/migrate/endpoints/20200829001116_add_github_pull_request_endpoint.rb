class AddGithubPullRequestEndpoint < ActiveRecord::Migration[5.2]
  def up
    Endpoint.new(name: 'get_pull_requests',
                 url_path: '/repos/:owner/:repo/pulls',
                 params: {owner: {type:'String', optional: false},
                          repo: {type:'String', optional: false},
                          state: {type: 'String', optional: true},
                          head: {type: 'String', optional: true},
                          sort: {type: 'String', optional: true},
                          direction: {type: 'String', optional: true}},
                    client_tag: 'github',
                    request_method: 'get',
                    body_template: nil).save!
  end

  def down
    Endpoint.where(name: 'get_pull_requests')
            .where(client_tag: 'github').first.try(:destroy)
  end
end
