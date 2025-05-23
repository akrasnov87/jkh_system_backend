class AddedActions < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :url_action, :integer
    add_column :push_templates, :data, :jsonb, default: {}
  end
end
