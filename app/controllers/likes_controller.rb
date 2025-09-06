class LikesController < ApplicationController
  before_action :authenticate_user!  

  def create
    @trade = Trade.find(params[:trade_id])
    @like = current_user.likes.new(trade: @trade)

    if @like.save
      # --- 投稿者に通知 ---
      Notification.create!(
        recipient: @trade.user,  # 投稿者
        actor: current_user,     # いいねしたユーザー
        action: "like",
        trade: @trade
      )

      # --- マッチング判定 ---
      check_matching(@trade, current_user)

      redirect_back(fallback_location: root_path, notice: "いいねしました")
    else
      redirect_back(fallback_location: root_path, alert: "いいねできませんでした")
    end
  end

  def destroy
    @like = Like.find_by(trade_id: params[:trade_id], user_id: current_user.id)
    @like.destroy if @like
    redirect_back(fallback_location: root_path, notice: "いいねを取り消しました")
  end

  private

  def check_matching(trade, user)
    # 投稿者が user の投稿に既にいいねしているか
    other_like = Like.find_by(user: trade.user, trade: user.trades)
    if other_like
      # --- マッチング成立 ---
      room = Room.create!
      
      # 両者の Entry を作成
      [user, trade.user].each do |u|
        Entry.create!(user: u, room: room)
      end

      # マッチング通知を作成（双方）
      [user, trade.user].each do |recipient|
        Notification.create!(
          recipient: recipient,
          actor: (recipient == user ? trade.user : user),
          action: "match",
          trade: trade,
          room: room
        )
      end
    end
  end
end
