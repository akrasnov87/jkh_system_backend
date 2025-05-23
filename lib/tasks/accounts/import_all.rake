namespace :accounts do
  desc 'import all account'
  task import_all: :environment do
    Account.companies.each_key do |company|
      AisImporter::Accounts.new(company).by_page
    end
  end
end
