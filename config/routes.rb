# frozen_string_literal: true

Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Attachinary::Engine => '/attachinary'

  # Setting Home
  root to: 'pages#home'

  # Routes related to Devise and Devise invitable
  devise_for :users,
             controllers: {
               invitations: 'users/invitations',
               omniauth_callbacks: 'users/omniauth_callbacks'
             }

  devise_scope :user do
    match '/groups/:group_id/invitations/new', to: 'users/invitations#new', via: 'get', as: 'new_group_invitation'
    match '/groups/:group_id/users/invitations', to: 'users/invitations#create', via: 'post'
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
      patch 'desinscription', to: 'slots#desinscription'
      patch 'desinscription_from_dashboard', to: 'slots#desinscription_from_dashboard'
    end
  end

  resources :users, only: %i(edit update)
  get 'profile', to: 'users#profile', as: :profile
  # get 'profile', to: 'pages#profile'
  # get 'profile/edit', to: 'pages#edit_profile'

  resources :orders, only: %i(show create) do
    resources :payments, only: %i(new create)
  end

  resources :coaches, only: %i(edit update)

  resources :users do
    resources :accounts, only: [ :new, :create, :edit, :update ]
  end

  # Hook routes for MangoPay
  get "orders/payment_succeeded/:id", to: "orders#payment_succeeded", as: :hook_payment_succeeded
  get "orders/payment_failed/:id", to: "orders#payment_failed", as: :hook_payment_failed

end
