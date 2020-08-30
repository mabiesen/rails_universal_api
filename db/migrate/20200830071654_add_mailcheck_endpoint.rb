class AddMailcheckEndpoint < ActiveRecord::Migration[5.2]
  def up
    Endpoint.new(name: 'get_email_validity',
                 url_path: '/api/check',
                 params: {email: {type:'String', optional: false},
                          smtp: {type:'String', optional: true},
                          format: {type: 'Date', optional: true}},
                    client_tag: 'mailboxlayer',
                    request_method: 'get',
                    body_template: nil).save!
  end

  def down
    Endpoint.where(name: 'get_email_validity')
            .where(client_tag: 'mailboxlayer').first.try(:destroy)
  end
end
