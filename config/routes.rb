Rails.application.routes.draw do
  # UI related

  get '/', to: 'home#index'
  get 'endpoint/:endpoint_id', to: 'home#endpoint'
  get 'endpoint/:client_tag/:request_name', to: 'home#endpoint'


  # API related

  default_format = { :format => 'json' }
  post '/list_endpoints', to: 'api#list_endpoints', :defaults => default_format
  post '/call/:client_tag/:request_name', to: 'api#call', :defaults => default_format
  post '/validate_params/:client_tag/:request_name', to: 'api#validate_params', :defaults => default_format
  post '/validate_param/:client_tag/:request_name', to: 'api#validate_param', :defaults => default_format
end
