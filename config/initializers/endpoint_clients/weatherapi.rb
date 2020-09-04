require 'faraday'
require 'faraday_middleware'

client_tag = :weatherapi

WEATHERAPI_CONFIG = Rails.application.config_for(client_tag)

WEATHERAPI_CLIENT = Faraday.new(WEATHERAPI_CONFIG['url']) do |f|
  f.request :retry
  f.response :json, :content_type => /\bjson$/
  f.adapter :net_http
  f.params['key'] =  ENV['WEATHERAPI_TOKEN']
end

# add to mapping
ApiClientMap[client_tag] = WEATHERAPI_CLIENT
