class ChangeColumnVerviceOrders < ActiveRecord::Migration[7.1]
  def change
    rename_column :service_payments, :service_orders_id, :service_order_id
  end
end
