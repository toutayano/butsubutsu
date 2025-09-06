class AddProfileToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :university, :string
    add_column :users, :grade, :string
    add_column :users, :faculty, :string
    add_column :users, :gender, :string
  end
end
