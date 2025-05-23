class AddedRoles < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :department, :integer, null: false, default: 0
  end
end
