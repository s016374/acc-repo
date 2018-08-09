class ChangeColumnOrderPhoneType < ActiveRecord::Migration[5.2]
  def change
    change_column :orders, :phone, :string
  end
end
