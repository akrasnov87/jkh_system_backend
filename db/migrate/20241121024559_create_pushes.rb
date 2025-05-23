class CreatePushes < ActiveRecord::Migration[7.1]
  def change
    create_table :pushes do |t|
      t.references :user, index: true, null: false
      t.string :title, null: false
      t.string :body, null: false
      t.string :whodunit, null: false
      t.boolean :is_new, null: false, default: true
      t.timestamps
    end
  end
end
