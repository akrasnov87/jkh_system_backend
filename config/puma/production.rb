## This is the file that puma will use,
## you can configure with set :puma_env, 'production'

max_threads_count = ENV.fetch('RAILS_MAX_THREADS', 4)
min_threads_count = ENV.fetch('RAILS_MIN_THREADS') { max_threads_count }
threads min_threads_count, max_threads_count
# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
port ENV.fetch('PORT', 3000)
# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch('RAILS_ENV', 'production')

# Specifies the `pidfile` that Puma will use.

if ENV['RAILS_ENV'] == 'production'
  require 'concurrent-ruby'
  worker_count = Integer(ENV.fetch('WEB_CONCURRENCY', Concurrent.physical_processor_count))
  workers worker_count if worker_count > 1
end

pidfile ENV.fetch('PIDFILE') { 'tmp/pids/puma.pid' }
