Rails.application.routes.draw do
  # Devise のルーティングで registrations をオーバーライド
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  resources :trades do
   resources :messages, only: [:create, :destroy]  # これを追加
   resources :likes, only: [:create, :destroy]
   resources :trade_rooms, only: [:create, :show] do
    resources :messages, only: [:create]
   end  
  end

  root 'trades#index'

  # プロフィール関連
  resources :users, only: [:index, :show]   # 他人のプロフィール用

  resources :notifications, only: [:index]

  resources :rooms, only: [:create, :show]

  resources :messages, only: [:create]

  get "mypage", to: "users#mypage", as: :mypage  # 自分専用ページ
  get "profile/edit", to: "users#edit_profile", as: :edit_profile
  put "profile", to: "users#update_profile", as: :update_profile
  

  # ヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check
end
