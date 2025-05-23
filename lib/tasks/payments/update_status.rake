namespace :payments do
  desc 'update payments'
  task update_status: :environment do
    PaymentsUpdateStatus.call
  end
end
