Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  default_format = { :format => 'json' }
  get '/list_endpoints', to: 'api#list_endpoints', :defaults => default_format
  post '/call/:client_tag/:request_name', to: 'api#call', :defaults => default_format
end
