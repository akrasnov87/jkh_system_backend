class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.bigint :user_id, index: true
      t.bigint :external_id, index: true, null: false
      t.bigint :number, index: true, null: false
      t.datetime :date_begin
      t.datetime :date_end
      t.string :address
      t.string :full_name
      t.integer :company, null: false, default: 0


      t.timestamps
    end
  end
end
