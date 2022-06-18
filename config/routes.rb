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
        put :bug_assignment
      end
    end
  end

  resources :projects do
    member do
      put :project_assignment
    end
  end
end
