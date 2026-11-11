Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  root "homes#top"
  resource :mypage, only: [:show]
  resources :maintenances do
    resources :comments, only: [:create, :destroy]
    resource :favorite, only: [:create, :destroy]
  end
  resources :cars, except: [:show] do
    resources :inspection_schedules, only: [:new, :create, :edit, :update, :destroy]
    resources :fuel_logs, only: [:new, :create, :destroy]
  end

  # サーバーが動いているか確認するためのURL（Rails 8の標準）
  get "up" => "rails/health#show", as: :rails_health_check
end