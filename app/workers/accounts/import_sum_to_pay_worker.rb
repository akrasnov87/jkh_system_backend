module Accounts
  class ImportSumToPayWorker
    include Sidekiq::Job
    sidekiq_options queue: 'accounts', retry: false

    def perform(user_id)
      user = User.find(user_id)
      user.accounts.each do |account|
        data_ready = Red.get("account_id-#{account.id}_order_data").nil?
        Red.setex("account_id-#{account.id}_order_data", 24.hours.to_i, account.id)
        AisImporter::Orders.new(account).call if data_ready && Rails.env.production?
      end
    end
  end
end
