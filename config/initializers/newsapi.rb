require 'faraday'
require 'faraday_middleware'

NEWSAPI_CONFIG = Rails.application.config_for(:newsapi)

NEWSAPI_CLIENT = Faraday.new(NEWSAPI_CONFIG['url']) do |f|
  f.request :retry
  f.response :json, :content_type => /\bjson$/
  f.adapter :net_http
  f.headers['X-Api-Key'] = '06b5d80da88c4d3d9ba3aeace741c1db'
end
