module Accounts
  class ImportByPhoneWorker
    include Sidekiq::Job
    sidekiq_options queue: 'accounts', retry: false

    def perform(user_id)
      companies = Account.companies.keys
      user = User.find(user_id)
      phone = Phone.new(user.phone).to_account
      companies.each do |company|
        AisImporter::Accounts.new(company).by_phone(user.phone, user)
        AisImporter::Accounts.new(company).by_phone(phone, user)
      end
    end
  end
end
