require 'faraday'
require 'faraday_middleware'

client_tag = :mailboxlayer

MAILBOXLAYER_CONFIG = Rails.application.config_for(client_tag)

MAILBOXLAYER_CLIENT = Faraday.new(MAILBOXLAYER_CONFIG['url']) do |f|
  f.request :retry
  f.response :json, :content_type => /\bjson$/
  f.adapter :net_http
  f.params['access_key'] =  ENV['MAILBOXLAYER_KEY']
end

# add to mapping
EndpointClientMap[client_tag] = MAILBOXLAYER_CLIENT
