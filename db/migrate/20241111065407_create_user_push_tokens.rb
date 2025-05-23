class CreateUserPushTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :user_push_tokens do |t|
      t.references :user, index: true, null: false
      t.string :token, null: false
      t.string :device_id, null: false
      t.timestamps
    end

    add_index :user_push_tokens, [:device_id, :token], unique: true
  end
end
