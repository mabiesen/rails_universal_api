require 'faraday'
require 'faraday_middleware'

MAILBOXLAYER_CONFIG = Rails.application.config_for(:mailboxlayer)

MAILBOXLAYER_CLIENT = Faraday.new(MAILBOXLAYER_CONFIG['url']) do |f|
  f.request :retry
  f.response :json, :content_type => /\bjson$/
  f.adapter :net_http
  f.params['access_key'] =  ENV['MAILBOXLAYER_KEY']
end
