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
    @like = current_user.likes.find(params[:id])
    @like.destroy
    redirect_back(fallback_location: root_path, notice: "いいねを削除しました")
  end

  private

  def check_matching(trade, user)
  Rails.logger.info "=== check_matching CALLED ==="
  Rails.logger.info "trade.user.id: #{trade.user.id}, user.id: #{user.id}"

  # 投稿者が自分の投稿にいいねしているか確認
  mutual_like_exists = Like.joins(:trade)
                           .where(user: trade.user, trades: { user_id: user.id })
                           .exists?

  Rails.logger.info "mutual_like_exists: #{mutual_like_exists}"
  return unless mutual_like_exists

  # 二重実行防止フラグ
  @matching_checked ||= {}
  room_key = [trade.user.id, user.id].sort.join("-")
  return if @matching_checked[room_key]
  @matching_checked[room_key] = true

  Rails.logger.info "=== MATCH FOUND! Room will be created ==="

  # Room の作成（ID順で固定）
  user1, user2 = [user, trade.user].sort_by(&:id)
  room = Room.find_or_create_by(user1: user1, user2: user2)
  Rails.logger.info "Room ID: #{room.id}"

  # 双方に通知（room_idを必ず保存）
  [user, trade.user].each do |recipient|
    actor = (recipient == user) ? trade.user : user
    Rails.logger.info "Creating match notification for recipient_id=#{recipient.id}, actor_id=#{actor.id}"

    Notification.where(recipient: recipient, actor: actor, action: "match").delete_all

    Notification.create!(
      recipient: recipient,
      actor: actor,
      action: "match",
      room: room  # ← ここで必ずroom_idを保存
    )
  end
  end
end