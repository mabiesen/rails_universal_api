Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/list_endpoints', to: 'api#list_endpoints'
  get '/request/:client_tag/:request_name', to: 'api#request'

  match "/404" => "errors#not_found", via: [:get, :post]
  match "/500" => "errors#exception", via: [:get, :post]
end
