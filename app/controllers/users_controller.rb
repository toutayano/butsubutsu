class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:mypage]

  # ユーザー一覧（必要なら残す）
  def index
    @users = User.all
  end

  # プロフィールページ
  def show
    @user = User.find(params[:id])
    @user_trades = @user.trades.order(created_at: :desc) || []# 新しい順
  end

  # 自分のマイページ
  def mypage
    @user = current_user
  # 空配列でも初期化しておく
    @my_trades = @user.trades.order(created_at: :desc) || []
    @liked_trades = @user.liked_trades.order(created_at: :desc) || []
  end

  # プロフィール編集画面
  def edit_profile
    @user = current_user
  end

  # プロフィール更新処理
  def update_profile
    @user = current_user
    if @user.update(profile_params)
      redirect_to mypage_path, notice: "プロフィールを更新しました"
    else
      render :edit_profile
    end
  end

  private

  # 更新可能なカラム
  def profile_params
    params.require(:user).permit(:nickname, :gender, :university, :grade, :faculty, :department, :avatar)
  end
end