class AddedDeletedAtToServicePayments < ActiveRecord::Migration[7.1]
  def change
    add_column :service_payments, :deleted_at, :datetime
    add_index :service_payments, :deleted_at
  end
end
