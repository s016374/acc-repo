class ChangeColumnType < ActiveRecord::Migration[5.0]
  def change
    change_column :items, :expected_price, :decimal, :precision => 8, :scale => 2
    change_column :items, :actual_price, :decimal, :precision => 8, :scale => 2
    change_column :items, :cost, :decimal, :precision => 8, :scale => 2
  end
end
