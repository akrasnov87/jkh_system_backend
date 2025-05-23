# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
set :bundle_command, '~/.rbenv/shims/bundle exec'
set :output, 'log/cron_log.log'
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 5.minutes do
  rake 'payments:update_status'
end

every 1.day, at: '11:40 pm' do
  rake 'tickets:check_sla'
end

every '0 16 20 * *' do
  rake 'user_notification:counter_push_notification'
end

every 1.day, at: '03:00 am' do
  rake 'payments:export'
  rake 'accounts:import_all'
  rake 'pushes:clean'
end
