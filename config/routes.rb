Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  root "homes#top"
  resources :maintenances
  resources :cars, except: [:show]

  # サーバーが動いているか確認するためのURL（Rails 8の標準）
  get "up" => "rails/health#show", as: :rails_health_check
end