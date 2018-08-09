class AddColumnIsPurchaseToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :is_purchase, :integer
  end
end
