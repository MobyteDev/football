Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/cable'

  post :user_token, to: 'user_token#create'
  resource :user do
    post :update_basket, on: :member
    post :add_achievement, on: :member
    get :get_rating, on: :member
  end

  post :superuser_token, to: 'superuser_token#create'
  resource :superuser do
    post :push_message_to_all, on: :member
    get :show_user, on: :member
  end

  resources :products
  resources :chants
  resources :achievements
  resources :categories

  resources :messages do
    get :get_history_general, on: :collection
  end

  resources :chats do
    get :get_chat_general, on: :collection
  end
end
