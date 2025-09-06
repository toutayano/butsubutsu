class CreateTrades < ActiveRecord::Migration[7.1]
  def change
    create_table :trades do |t|
      t.string :name
      t.string :condition
      t.string :category
      t.text :detail

      t.timestamps
    end
  end
end
