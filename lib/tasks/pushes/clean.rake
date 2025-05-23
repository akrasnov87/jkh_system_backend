namespace :pushes do
  desc 'clean pushes'
  task clean: :environment do
    Push.where('created_at < ?', Time.current - 1.month).destroy_all
  end
end
