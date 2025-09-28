class AddUsersToRooms < ActiveRecord::Migration[7.1]
  def change
    add_reference :rooms, :user1, null: false, foreign_key: false
    add_reference :rooms, :user2, null: false, foreign_key: false
  end
end
