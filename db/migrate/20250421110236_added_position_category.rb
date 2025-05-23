class AddedPositionCategory < ActiveRecord::Migration[7.1]
  def change
    add_column :service_categories, :position, :integer, null: false, default: 0
    add_column :service_works, :position, :integer, null: false, default: 0
  end
end
