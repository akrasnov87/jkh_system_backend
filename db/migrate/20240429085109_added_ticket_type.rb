class AddedTicketType < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :status, :integer, null: false, default: 0
  end
end
