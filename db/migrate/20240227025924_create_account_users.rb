class CreateAccountUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :account_users do |t|
      t.bigint :account_id, index: true, null: false
      t.bigint :user_id, index: true, null: false
      t.timestamps
    end

    remove_column :accounts, :user_id
  end
end
