class AddedPaymentIndex < ActiveRecord::Migration[7.1]
  def change
    add_index :payments, :status
  end
end