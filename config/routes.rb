Rails.application.routes.draw do
  root 'events#index'
  devise_for :users
  resources :users, only: [:show]
  resources :events do
    resources :event_attendances, only: [:create, :destroy]
    resources :invitations, only: [:new, :create, :index]
  end

  resources :invitations, only: [:edit, :update, :destroy] do
    member do
      get :respond_to_invitation
    end
  end

  resources :notifications, only: [:index] do
    member do
      put :mark_as_read
    end
  end

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
end
