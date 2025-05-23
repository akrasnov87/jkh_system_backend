class AddedDataToPush < ActiveRecord::Migration[7.1]
  def change
    add_column :pushes, :data, :jsonb, default: {}
  end
end
