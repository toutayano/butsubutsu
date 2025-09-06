class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.integer :recipient_id, null: false   # 通知を受けるユーザー
      t.integer :actor_id, null: false       # 行動したユーザー（いいねした人など）
      t.string :action, null: false          # 'like' や 'match'
      t.integer :trade_id                     # 対象の投稿
      t.integer :room_id                      # マッチング時のDMルームID
      t.datetime :read_at                     # 既読管理用
      t.timestamps
    end

    add_index :notifications, :recipient_id
    add_index :notifications, :actor_id
    add_index :notifications, :trade_id
    add_index :notifications, :room_id
  end
end
