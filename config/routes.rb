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

  resources :battles, only: [:create, :show, :index] do
    member do
      get :image, defaults: { format: 'png' }
    end
  end

  get 'feeds/yandex', defaults: { format: 'xml' }

  get 'welcome/rules'
  get 'welcome/long'

  root 'welcome#index'
end
