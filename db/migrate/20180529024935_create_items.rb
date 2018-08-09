class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.belongs_to :vendor

      t.string :title
      t.integer :stock
      t.integer :total
      t.integer :expected_price
      t.integer :actual_price
      t.integer :cost
      t.integer :type
      t.string :description

      t.timestamps
    end
  end
end
