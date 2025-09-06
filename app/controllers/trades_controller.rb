class TradesController < ApplicationController
  # ログイン必須アクション
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  # 投稿取得・権限チェック
  before_action :set_trade, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  # 一覧ページ
  def index
    if user_signed_in?
      # 自分以外の投稿を取得
      @trades = Trade.where.not(user_id: current_user.id)
    else
      # ログインしていない場合は全投稿を表示
      @trades = Trade.all
    end
  end

  # 詳細ページ
  def show
  # set_trade で @trade は取得済み
  # 投稿に紐づくコメントを取得（N+1対策として user も一緒に読み込む）
  @messages = @trade.messages.includes(:user)
  end

  # 新規投稿フォーム
  def new
    @trade = Trade.new
  end

  # 投稿作成
  def create
    @trade = current_user.trades.build(trade_params)

    if @trade.save
      redirect_to trades_path, notice: "投稿を作成しました"
    else
      # エラーがある場合はフォームを再表示
      render :new, status: :unprocessable_entity
    end
  end

  # 編集フォーム
  def edit
  end

  # 投稿更新
  def update
    if @trade.update(trade_params)
      redirect_to trade_path(@trade), notice: "投稿を更新しました"
    else
      render :edit
    end
  end

  # 投稿削除
  def destroy
    @trade.destroy
    redirect_to mypage_path, notice: "投稿を削除しました"
  end

  private

  # 投稿取得
  def set_trade
    @trade = Trade.find(params[:id])
  end

  # 投稿権限チェック（自分の投稿のみ編集・削除可能）
  def authorize_user!
    unless @trade.user == current_user
      redirect_to trades_path, alert: "権限がありません"
    end
  end

  # ストロングパラメータ
  def trade_params
    params.require(:trade).permit(:name, :image, :category, :condition, :detail).merge(user: current_user)
  end
end
