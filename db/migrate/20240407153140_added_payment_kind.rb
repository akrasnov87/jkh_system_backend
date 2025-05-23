class AddedPaymentKind < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :kind, :integer, default: 0
  end
end
