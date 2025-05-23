class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :account, null: false, foreign_key: true
      t.string :month
      t.string :year
      t.decimal :sum_to_pay, precision: 10, scale: 2
      t.timestamps
    end
  end
end
