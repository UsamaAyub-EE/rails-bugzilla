# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'
  devise_for :users, path: 'users', controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    authenticated :user do
      namespace :users do
        get 'dashboard/index', as: :authenticated_root
      end
    end
  end

  resources :users do
    resources :projects do
      resources :bugs
    end
  end

  resources :projects do
    member do
      post :add_developer
      put :add_developer
      delete :remove_developer
    end
  end

  resources :projects do
    resources :bugs do
      member do
        patch :pick_developer
        put :pick_developer
        patch :drop_developer
        put :drop_developer
        patch :mark_as_resolved
        put :mark_as_resolved
      end
    end
  end
end
