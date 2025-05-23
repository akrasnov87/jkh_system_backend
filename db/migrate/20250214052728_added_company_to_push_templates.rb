class AddedCompanyToPushTemplates < ActiveRecord::Migration[7.1]
  def change
    add_column :push_templates, :company, :integer
    add_index :push_templates, :company
  end
end
