class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.create
    Entry.create(room_id: @room.id, user_id: current_user.id)
    Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id))
    redirect_to room_path(@room)
  end

  def show
    @room = Room.find(params[:id])

    # 自分の Entry がなければ作成
    Entry.find_or_create_by(user_id: current_user.id, room_id: @room.id)

    @messages = @room.messages.order(:created_at)
    @message = Message.new
    @entries = @room.entries
  end
end
