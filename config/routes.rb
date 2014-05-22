BikeCommuteChallenge::Application.routes.draw do
  get "dashboard" => "dashboard#index"
  get "help" => "home#index"
  get "rules" => "home#rules"
  get "sponsors" => "home#sponsors"

  devise_for :users, controllers: { registrations: :registrations }

  resources :competitions do
    get :delete, on: :member
    resources :brackets
    resources :competitors do
      get :delete, on: :member
    end

  end

  resources :teams do
    get :delete, on: :member
    resources :memberships do
      get :delete, on: :member
    end
  end

  resources :rides do
    get :delete, on: :member
  end

  resources :users, only: %i{show}

  authenticated :user do
    root :to =>"dashboard#index", as: :user_root
  end

  root to: "home#index"
end
