# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'
  devise_for :users

  resources :users do
    resources :projects do
      resources :bugs
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
