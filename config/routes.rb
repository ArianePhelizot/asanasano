Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Attachinary::Engine => "/attachinary"
  devise_for :users
  root to: 'pages#home'
  # On a une route pour toutes les méthodes de group sauf pour show car on affiche les groups dans le dashboard...
  # ... et non dans leur propre show
  resources :groups, only: [:new, :create, :edit, :update, :destroy] do
    # On nest ces routes car on a besoin de group_id pour new, create, edit et update
    resources :courses, only: [:new, :create, :edit, :update] do
      # On nest ces routes car on a besoin du course_id pour new, create, edit et update
      # On affiche les slots dans la show de course donc pas de slots#show
      # On ne veut pas destroy un slot car on veut garder l'historique.
      # On veut simplement passer son statut à "cancelled", donc pas de slots#destroy
      resources :slots, only: [:new, :create, :edit, :update]
    end
  end

  resources :courses, only: [:show, :destroy] # on n'a pas besoin de group_id pour show ou destroy un course

  get 'dashboard', to: 'pages#dashboard'

  resources :orders, only: [:show, :create] do
    resources :payments, only: [:new, :create]
  end
end
