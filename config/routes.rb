Rails.application.routes.draw do
  scope "(:locale)", locale: /ja|en/ do
    get 'password_resets/new'
    get 'password_resets/edit'
    get 'sessions/new'
    root "static_pages#home"
    get  "/agreement", to: "static_pages#agreement"
    get  "/policy", to: "static_pages#policy"
    get  "/help", to: "static_pages#help"
    get  "/contact", to: "static_pages#contact"
    get  "/signup",  to: "users#new"
    get    "/login",   to: "sessions#new"
    post   "/login",   to: "sessions#create"
    delete "/logout",  to: "sessions#destroy"
    resources :users
    resources :account_activations, only: [:edit]
    resources :password_resets,     only: [:new, :create, :edit, :update]
    resources :events do
      collection do
        get :viewed_history
      end
    end
    get  "/my_events", to: "events#my_events"
    get  "/search", to: "events#index"
    resources :bookmarks, only: [:index, :create, :destroy]
    get "/my_bookmarks", to: "bookmarks#index"
    resources :event_reminders, only: [:index]
    resources :notices, only: [:index]
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
