class AddMessageIdToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_reference :notifications, :message, null: true, foreign_key: true
  end
end
