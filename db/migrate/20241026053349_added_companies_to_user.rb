class AddedCompaniesToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :companies, :string, array: true, default: []
  end
end
