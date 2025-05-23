class AddedActualToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :actual_payment, :boolean, null: false, default: false
  end
end
