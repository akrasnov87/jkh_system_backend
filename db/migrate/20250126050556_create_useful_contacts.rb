class CreateUsefulContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :useful_contacts do |t|
      t.string :name, null: false
      t.string :number, null: false
      t.integer :company, null: false

      t.timestamps
    end
  end
end
