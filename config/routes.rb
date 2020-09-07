Rails.application.routes.draw do
  # UI related

  get '/', to: 'home#index'
  get '/home/endpoint/:endpoint_id', to: 'home#endpoint_page'
  get '/home/endpoint/:client_tag/:request_name', to: 'home#endpoint_page'


  # API related

  default_format = { :format => 'json' }
  post '/list_endpoints', to: 'api#list_endpoints', :defaults => default_format
  post '/call/:client_tag/:request_name', to: 'api#call', :defaults => default_format
  post '/validate_params/:client_tag/:request_name', to: 'api#validate_params', :defaults => default_format
  post '/validate_param/:client_tag/:request_name', to: 'api#validate_param', :defaults => default_format
end
