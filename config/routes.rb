Rails.application.routes.draw do
  devise_for :users

  root "homes#top"
  resources :maintenances, only: [:index, :show]
  resources :cars, except: [:show]

  # サーバーが動いているか確認するためのURL（Rails 8の標準）
  get "up" => "rails/health#show", as: :rails_health_check
end