module Accounts
  class ImportByExternalIdWorker
    include Sidekiq::Job
    sidekiq_options queue: 'accounts', retry: false

    def perform(external_id, company)
      AisImporter::Accounts.new(company).account_by_external_id(external_id)
    end
  end
end
