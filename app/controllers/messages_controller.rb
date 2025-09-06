class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    if params[:message][:room_id].present?
      # ✅ DMメッセージ
      @room = Room.find(params[:message][:room_id])
      @message = current_user.messages.new(message_params.merge(room: @room))

    elsif params[:message][:trade_id].present?
      # ✅ 投稿チャット
      @trade = Trade.find(params[:message][:trade_id])
      @message = current_user.messages.new(message_params.merge(trade: @trade))
    else
      redirect_back(fallback_location: root_path, alert: "送信先が不明です") and return
    end

    if @message.save
      # ======== 通知処理開始 ========
      if @message.trade_id.present?
        # 1. これまでにこの投稿にメッセージしたことがあるユーザー（自分以外）を取得
        participants = @trade.messages
                              .where.not(user_id: current_user.id)
                              .select(:user_id)
                              .distinct
                              .map(&:user)

        # 2. 投稿者も対象に追加（自分以外）
        participants << @trade.user if @trade.user != current_user
        participants.uniq! # 重複を削除

        # 3. 通知を送信
        participants.each do |recipient|
          Notification.create!(
            recipient: recipient,    # 通知を受け取る人
            actor: current_user,     # メッセージを送信した人（自分）
            action: "message",
            trade: @trade,
            message: @message
          )
        end
      end

      respond_to do |format|
        format.html do
          if @message.trade_id.present?
            redirect_to trade_path(@message.trade_id)
          else
            redirect_to room_path(@message.room_id)
          end
        end
        format.js   # create.js.erb が呼ばれる
      end
    else
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path, alert: "送信失敗") }
        format.js   { render js: "alert('送信できませんでした')" }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :trade_id, :room_id)
  end
end