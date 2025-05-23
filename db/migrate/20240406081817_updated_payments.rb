class UpdatedPayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.bigint :account_id, null: false, index: true
      t.integer :status, null: false, default: 0
      t.string :order_id
      t.string :rq_uid, null: false
      t.string :order_form_url
      t.string :order_sum

      t.timestamps
    end
  end
end
