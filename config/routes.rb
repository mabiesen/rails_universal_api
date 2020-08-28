Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/list_endpoints', to: 'api#list_endpoints'
  get '/request', to: 'api#request'
end
