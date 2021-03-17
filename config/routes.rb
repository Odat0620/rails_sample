Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'   
  } 

  devise_scope :user do
    get "sign_in", :to => "users/sessions#new"
    get "sign_out", :to => "users/sessions#destroy" 
  end

  resources :users, only: [:show]
  resources :posts do
    resources :comments, only: %i[create destroy]
    resources :likes, only: %i[create destroy]
  end

  root 'posts#index'
end
