Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end

  root "homes#top"
  resources :users, only: [:show]
  resources :favorites, only: [:index]
  resource :mypage, only: [:show]
  resource :profile, only: [:edit, :update]
  resources :maintenances do
    resources :comments, only: [:create, :destroy]
    resource :favorite, only: [:create, :destroy]
  end
  resources :groups do
    # 自分の参加申請・取り消し・退出
    resource :membership, only: [:create, :destroy]
    # オーナーによる承認・拒否・メンバーの削除
    resources :group_users, only: [:update, :destroy]
  end
  resources :cars do
    resources :inspection_schedules, only: [:new, :create, :edit, :update, :destroy]
    resources :fuel_logs, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  # サーバーが動いているか確認するためのURL（Rails 8の標準）
  get "up" => "rails/health#show", as: :rails_health_check
end