Rails.application.routes.draw do
  # 管理者のログイン（/admin/sign_in）。新規登録とパスワード再設定の画面は作らない
  devise_for :admins, path: "admin", skip: [:registrations, :passwords],
                      controllers: { sessions: "admin/sessions" }

  namespace :admin do
    root "dashboards#show"
    resources :users, only: [:index, :show, :destroy] do
      patch :restore, on: :member
    end
    resources :maintenances, only: [:index, :destroy] do
      patch :restore, on: :member
    end
    resources :groups, only: [:index, :destroy] do
      patch :restore, on: :member
    end
    resources :comments, only: [:index, :destroy] do
      patch :restore, on: :member
    end
  end

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
    delete "users/guest_to_sign_up", to: "users/sessions#guest_to_sign_up"
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
    # オーナーからメンバーへのお知らせ（メールも送る）
    resources :notices, only: [:new, :create], controller: "group_notices"
  end
  resources :cars do
    resources :inspection_schedules, only: [:new, :create, :edit, :update, :destroy]
    resources :fuel_logs, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  # 開発中だけ：送ったメールをブラウザで確認する画面
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # サーバーが動いているか確認するためのURL（Rails 8の標準）
  get "up" => "rails/health#show", as: :rails_health_check
end