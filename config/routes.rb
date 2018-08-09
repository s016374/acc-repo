Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users

  root 'orders#index'

  resources :orders do
    resources :goods do
    end
    collection do
      get :purchase
      get :get_items
    end
  end

  resources :vendors do
    resources :items do
    end
  end

end
