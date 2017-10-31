# frozen_string_literal: true

Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Attachinary::Engine => '/attachinary'

  # Setting Home
  root to: 'pages#home'

  # Page pro
  get 'pro', to:'pages#pro', as: :pro

  # Routes related to Devise and Devise invitable
  devise_for :users,
             controllers: {
               invitations: 'users/invitations',
               omniauth_callbacks: 'users/omniauth_callbacks'
             }

  devise_scope :user do
    match '/groups/:group_id/invitations/new', to: 'users/invitations#new', via: 'get', as: 'new_group_invitation'
    match '/groups/:group_id/users/invitations', to: 'users/invitations#create', via: 'post'
    get   "users/sign_up_pro" , to:  "devise_invitable/registrations#newpro", :as => :new_pro_user_registration
    post "users_pro", to:  "devise_invitable/registrations#createpro", :as => :user_pro_registration
  end


  # Dashboard
  get 'dashboard', to: 'pages#dashboard', as: :dashboard

  patch 'courses/:id/publish', to: 'courses#publish', as: :course_publish
  patch 'courses/:id/depublish', to: 'courses#depublish', as: :course_depublish
  # On a une route pour toutes les méthodes de group sauf pour show car on affiche les groups dans le dashboard...
  # ... et non dans leur propre show
  resources :groups, only: %i(new create edit update destroy) do
    # On nest ces routes car on a besoin de group_id pour new, create, edit et update
    resources :courses, only: %i(new create edit update)
  end

  get 'groups/:id/participants', to: 'groups#group_participants', as: :group_participants
  get 'groups/:id/remove_current_user_from_group', to: 'groups#remove_current_user_from_group', as: :remove_current_user_from_group

  resources :courses, only: %i(show destroy) do
    # On neste ces routes ici car on a besoin du course_id pour new, create, edit et update (mais pas group_id)
    # On affiche les slots dans la show de course donc pas de slots#show
    # On ne veut pas destroy un slot car on veut garder l'historique.
    # On veut simplement passer son statut à "cancelled", donc pas de slots#destroy
    resources :slots, only: %i(new create edit update)
  end # on n'a pas besoin de group_id pour show ou destroy un course

  resources :slots do
    member do
      patch 'desinscription_from_course_page', to: 'slots#desinscription_from_course_page'
      patch 'desinscription_from_dashboard', to: 'slots#desinscription_from_dashboard'
      patch 'cancel', to: 'slots#cancel'
    end
  end

  resources :users, only: %i(edit update)
  get 'profile', to: 'users#profile', as: :profile
  # get 'profile', to: 'pages#profile'
  # get 'profile/edit', to: 'pages#edit_profile'

  resources :orders, only: %i(show create) do
# check avant de supprimer
    # collection do
    #   # Hook routes for MangoPay
    #   get '/payment_succeeded', to: 'orders#payment_succeeded'
    #   get '/payment_failed', to: 'orders#payment_failed'
    # end
    resources :payments, only: %i(new create)
  end

  resources :coaches, only: %i(new create edit update)

  resources :users do
    resources :accounts, only: [ :new, :create, :edit, :update ]
  end

  resources :users do
    resources :ibans, only: [ :new, :create, :edit, :update ]
  end

  #Hooks routes
    get '/hooks/payment_succeeded', to: 'hooks#payment_succeeded'
    get '/hooks/payment_failed', to: 'hooks#payment_failed'
    get '/hooks/payin_refund_succeeded', to: 'hooks#payin_refund_succeeded'
    get '/hooks/payin_refund_failed', to: 'hooks#payin_refund_failed'
    get '/hooks/payout_normal_succeeded', to: 'hooks#payout_normal_succeeded'
    get '/hooks/payout_normal_failed', to: 'hooks#payout_normal_failed'

# Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

end
