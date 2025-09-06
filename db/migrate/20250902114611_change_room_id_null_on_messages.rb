class ChangeRoomIdNullOnMessages < ActiveRecord::Migration[7.1]
  def change
    change_column_null :messages, :room_id, true
  end
end
