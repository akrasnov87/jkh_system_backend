class CreateRewards < ActiveRecord::Migration[7.1]
  def change
    create_table :rewards do |t|
      t.integer :company, null: false
      t.string :title, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
