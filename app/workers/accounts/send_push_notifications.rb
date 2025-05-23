module Accounts
  class SendPushNotifications
    include Sidekiq::Job
    sidekiq_options queue: 'push', retry: false

    def perform(accounts_ids, push_template_id, whodunit)
      user_ids = AccountUser.where(account_id: accounts_ids).map(&:user_id).uniq
      push_template = PushTemplate.find(push_template_id)
      PushNotifiersService.new(user_ids, push_template, whodunit).call
    end
  end
end
