class AddIndexToVendor < ActiveRecord::Migration[5.0]
  def change
    add_index :vendors, :title, unique: true
  end
end
