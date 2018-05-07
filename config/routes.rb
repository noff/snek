Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users


  resources :sneks do
    member do
      get :rules
      put :save_rules
      put :auto_fight
    end
  end

  resources :battles, only: [:create] do
  end

  get 'welcome/rules'

  root 'welcome#index'
end
