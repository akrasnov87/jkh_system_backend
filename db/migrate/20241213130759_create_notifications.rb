class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.integer :company, null: false
      t.integer :image, null: false
      t.string :title, null: false
      t.text :body, null: false
      t.boolean :active, null: false, default: false
      t.string :whodunit
      t.timestamps
    end
  end
end
