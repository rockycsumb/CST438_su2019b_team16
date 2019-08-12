Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    get '/orders/:id', to: 'orders#show'
    get '/orders', to: 'orders#search'
    post '/orders', to: 'orders#create'
    
end
