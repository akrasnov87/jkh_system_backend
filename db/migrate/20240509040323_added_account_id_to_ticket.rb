class AddedAccountIdToTicket < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :account_id, :bigint
    add_index :tickets, :account_id
    add_column :counters, :label, :string
    add_column :account_users, :label, :string
  end
end
