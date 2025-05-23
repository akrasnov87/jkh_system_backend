class ChnageNumberColumn < ActiveRecord::Migration[7.1]
  def change
    change_column :accounts, :number, :string
  end
end
