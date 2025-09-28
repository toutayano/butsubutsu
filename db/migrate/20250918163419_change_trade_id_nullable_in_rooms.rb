class ChangeTradeIdNullableInRooms < ActiveRecord::Migration[7.1]
  def change
    change_column_null :rooms, :trade_id, true
  end
end
