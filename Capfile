require 'capistrano/setup'
# Include default deployment tasks
require 'capistrano/deploy'
require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git
require 'capistrano/bundler'
require "capistrano/rbenv"
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/puma'
require 'capistrano/sidekiq'
require "whenever/capistrano"
install_plugin Capistrano::Puma
install_plugin Capistrano::Puma::Systemd

install_plugin Capistrano::Sidekiq  # Default sidekiq tasks
# Then select your service manager
install_plugin Capistrano::Sidekiq::Systemd
# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }