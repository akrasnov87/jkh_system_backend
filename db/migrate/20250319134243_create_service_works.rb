class CreateServiceWorks < ActiveRecord::Migration[7.1]
  def change
    create_table :service_works do |t|
      t.references :service_category, null: false, index: true
      t.string :name, null: false
      t.integer :company, null: false

      t.timestamps
    end
  end
end
