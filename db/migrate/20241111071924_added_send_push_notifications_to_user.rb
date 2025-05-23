class AddedSendPushNotificationsToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :send_push_notifications, :boolean, null: false, default: true
  end
end
