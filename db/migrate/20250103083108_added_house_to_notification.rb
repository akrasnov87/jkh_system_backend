class AddedHouseToNotification < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :house, :string
    add_column :notifications, :kind, :integer,  default: 0, null: false
    change_column_null :notifications, :company, true
  end
end
