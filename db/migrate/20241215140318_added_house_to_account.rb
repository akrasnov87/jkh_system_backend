class AddedHouseToAccount < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :house, :string
  end
end
