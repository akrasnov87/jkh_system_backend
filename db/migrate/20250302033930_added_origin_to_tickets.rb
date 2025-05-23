class AddedOriginToTickets < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :origin, :integer, default: 0
  end
end
