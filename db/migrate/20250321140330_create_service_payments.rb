class CreateServicePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :service_payments do |t|
      t.references :service_orders, null: false
      t.integer :status, null: false, default: 0, index: true
      t.string :order_id
      t.string :rq_uid, null: false
      t.string :order_form_url
      t.string :order_sum
      t.string :id_qr

      t.timestamps
    end
  end
end
