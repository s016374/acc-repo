class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :customer
      t.integer :phone
      t.string :address
      t.string :comment

      t.timestamps
    end
  end
end
