Rails.application.routes.draw do

  get 'ratings/top'
  get 'ratings/national'

  get 'billing' => 'billing#index'
  put 'billing/addcard'
  post 'billing/webhook', defaults: {format: :json}


  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {
      registrations: 'users/registrations'
  }


  resources :paid_subscriptions, only: [:create]

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
