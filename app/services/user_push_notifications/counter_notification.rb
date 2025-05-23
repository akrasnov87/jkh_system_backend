module UserPushNotifications
  class CounterNotification
    def self.call
      push_template = OpenStruct.new({ title: 'Пришло время передать показания счетчиков',
                                       body: 'В разделе "Счетчики" вы можете передать показаниия',
                                       data: { url_action: 'metersPage' } })
      user_ids = User.joins(:accounts).where(users: { send_push_notifications: true }).pluck(:id).uniq
      PushNotifiersService.new(user_ids, push_template, 'system').call
    end
  end
end
