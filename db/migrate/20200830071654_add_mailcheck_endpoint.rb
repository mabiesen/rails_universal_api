class AddMailcheckEndpoint < ActiveRecord::Migration[5.2]
  def change
    Endpoint.new(name: 'get_email_validity',
                 url_path: '/api/check',
                 params: {email: {type:'String', optional: false},
                          smtp: {type:'String', optional: true},
                          format: {type: 'Date', optional: true}},
                    client_tag: 'mailboxlayer',
                    request_method: 'get',
                    body_template: nil).save!
  end
end
