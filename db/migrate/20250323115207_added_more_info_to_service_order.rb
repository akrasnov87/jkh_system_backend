class AddedMoreInfoToServiceOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :service_orders, :company, :integer, null: false
    add_column :service_orders, :phone, :string, null: false
    add_column :service_orders, :address, :string, null: false
    add_column :service_orders, :full_name, :string, null: false
    add_column :service_orders, :number, :string, null: false
  end
end
