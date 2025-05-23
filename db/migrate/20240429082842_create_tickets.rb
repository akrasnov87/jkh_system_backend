class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.references :user, index: true, null: false
      t.string :subject
      t.text :description
      t.timestamps
    end
  end
end
