class AddedPhoneToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :phone, :string
  end
end
