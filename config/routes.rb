Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Attachinary::Engine => "/attachinary"
  devise_for :users
  root to: 'pages#home'
  resources :groups, only: [:new, :create, :edit, :update, :destroy] do
    # on nest ces routes car on a besoin de group_id pour new, create, edit et update
    resources :courses, only: [:new, :create, :edit, :update]
  end
  resources :courses, only: [:show, :destroy] # on n'a pas besoin de group_id pour show ou destroy un course
  get 'dashboard', to: 'pages#dashboard'
end
