class DropCommentsTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :comments, if_exists: true
  end

  def down
    # 誤ってマイグレーションを戻した時に復元できるよう定義
    create_table :comments do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :trade, null: false, foreign_key: true
      t.timestamps
    end
  end
end
