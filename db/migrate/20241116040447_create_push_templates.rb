class CreatePushTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :push_templates do |t|
      t.string :title, null: false
      t.string :body, null: false

      t.timestamps
    end
  end
end
