class AddTradeToMessages < ActiveRecord::Migration[7.1]
  def change
    add_reference :messages, :trade, null: true, foreign_key: true
  end
end
