namespace :user_notification do
  desc 'counter_push_notification'
  task counter_push_notification: :environment do
    UserPushNotifications::CounterNotification.call
  end
end
