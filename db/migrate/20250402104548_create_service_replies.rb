class CreateServiceReplies < ActiveRecord::Migration[7.1]
  def change
    create_table :service_replies do |t|
      t.references :user, index: true, null: false
      t.references :service_order, index: true, null: false
      t.integer :kind, null: false, default: 0
      t.string :subject
      t.text :description
      t.timestamps
    end
  end
end
