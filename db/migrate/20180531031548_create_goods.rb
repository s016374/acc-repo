class CreateGoods < ActiveRecord::Migration[5.0]
  def change
    create_table :goods do |t|
      t.belongs_to :order

      t.string :title
      t.decimal :price, :precision => 8, :scale => 2
      t.integer :number

      t.timestamps
    end
  end
end
