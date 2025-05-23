class CreateApiTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :api_tokens do |t|
      t.bigint :user_id, null: false, index: true
      t.string :token, null: false, index: true
      t.string :devise_id
      t.integer :kind, default: 0, null: false

      t.timestamps
    end

    change_column :users, :role, :integer, default: 0, null: false
  end
end
