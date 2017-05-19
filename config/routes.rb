Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Attachinary::Engine => "/attachinary"
  devise_for :users
  root to: 'pages#home'
  resources :groups, only: [:new, :create, :edit, :update, :destroy] do
    #we nest course routes under group routes because we need group_id to create a course
    resources :courses, only: [:new, :create, :edit, :update]
  end
  resources :courses, only: [:show, :destroy]
  get 'dashboard', to: 'pages#dashboard'
end
