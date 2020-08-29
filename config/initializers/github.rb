require 'faraday'
require 'faraday_middleware'

GITHUB_CONFIG = Rails.application.config_for(:github)

GITHUB_CLIENT = Faraday.new(GITHUB_CONFIG['url']) do |f|
  f.request :retry
  f.request :basic_auth, ENV['GITHUB_USER'], ENV['GITHUB_PASSWORD']
  f.response :json, :content_type => /\bjson$/
  # simultaneously indicating json and v3 versioning for api
  f.headers['Accept'] = 'application/vnd.github.v3+json'
  f.adapter :net_http
end
