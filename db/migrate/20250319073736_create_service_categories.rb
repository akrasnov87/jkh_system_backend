class CreateServiceCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :service_categories do |t|
      t.integer :company, null: false
      t.string :name, null: false
      t.integer :image
      t.timestamps
    end
  end
end
