class CreateServiceOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :service_orders do |t|
      t.references :account
      t.references :user
      t.references :service_category
      t.references :service_work
      t.integer :status, default: 0, index: true
      t.string :subject, null: false, index: true
      t.text :description

      t.timestamps
    end
  end
end
