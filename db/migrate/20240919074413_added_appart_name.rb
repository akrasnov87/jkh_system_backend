class AddedAppartName < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :apart_name, :string
    add_column :accounts, :apart_name_ext, :string
  end
end
