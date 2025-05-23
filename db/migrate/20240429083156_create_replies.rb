class CreateReplies < ActiveRecord::Migration[7.1]
  def change
    create_table :replies do |t|
      t.references :user, index: true, null: false
      t.references :ticket, index: true, null: false
      t.integer :kind, null: false, default: 0
      t.string :subject
      t.text :description
      t.timestamps
    end
  end
end
