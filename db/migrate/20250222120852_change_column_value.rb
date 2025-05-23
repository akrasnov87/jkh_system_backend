class ChangeColumnValue < ActiveRecord::Migration[7.1]
  def change
    rename_column :tariffs, :value, :explanation
  end
end
