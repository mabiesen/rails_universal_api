require 'faraday'
require 'faraday_middleware'

client_tag = :newsapi

NEWSAPI_CONFIG = Rails.application.config_for(client_tag)

NEWSAPI_CLIENT = Faraday.new(NEWSAPI_CONFIG['url']) do |f|
  f.request :retry
  f.response :json, :content_type => /\bjson$/
  f.adapter :net_http
  f.params['apiKey'] = ENV['NEWSAPI_KEY']
end

# add to mapping
ApiClientMap[client_tag] = NEWSAPI_CLIENT
