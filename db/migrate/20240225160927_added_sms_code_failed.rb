class AddedSmsCodeFailed < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :sms_code_failed_attempts, :integer, null: false, default: 0
    add_column :users, :sms_code, :string
    add_column :users, :sms_code_sended_at, :datetime
  end
end
