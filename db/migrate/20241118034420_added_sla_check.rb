class AddedSlaCheck < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :sla_started_at, :datetime
    add_column :tickets, :sla_expired, :boolean, null: false, default: false
    add_index :tickets, :sla_started_at
    add_index :users, :send_push_notifications
  end
end
