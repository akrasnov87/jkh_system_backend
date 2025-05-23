namespace :payments do
  desc 'export payments'
  task export: :environment do
    Account.companies.each_key do |company|
      Payments::Exporter.new(company).call
    end
  end
end
