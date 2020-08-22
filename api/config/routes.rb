Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/cable'

  post :user_token, to: 'user_token#create'
  resource :user do
    post :update_basket, on: :member
  end

  post :superuser_token, to: 'superuser_token#create'
  resource :superuser

  resources :products
  resources :categories

  resources :messages do
    get :get_history_general, on: :collection
  end

  resources :chats
end
