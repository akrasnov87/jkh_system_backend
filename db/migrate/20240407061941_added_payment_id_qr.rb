class AddedPaymentIdQr < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :id_qr, :string
  end
end
