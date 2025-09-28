class AddTradeToRooms < ActiveRecord::Migration[7.1]
  def change
    add_reference :rooms, :trade, null: false, foreign_key: true
  end
end
