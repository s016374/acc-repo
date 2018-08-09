class FixColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :items, :type, :style
  end
end
