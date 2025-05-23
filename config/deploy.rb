# config valid for current version and patch releases of Capistrano
LINKED_FILES = %w(.env config/secrets.yml).freeze

LINKED_DIRS = %w(log tmp/pids tmp/cache tmp/sockets cert storage).freeze
deploy_user = (ENV.fetch('GITLAB_USER_LOGIN', nil) || `git config user.name`).chomp
branch_name = (
  ENV.fetch('CI_COMMIT_REF_NAME', nil) ||
    ENV.fetch('CI_COMMIT_BRANCH', nil) ||
    `git rev-parse --abbrev-ref HEAD`
).chomp
lock "~> 3.18.0"

set :application, "backend"
set :repo_url, "git@gitlab.com:jkh_system/backend.git"
set :user, 'razrab'
set :branch, branch_name
set :linked_files, fetch(:linked_files, []) + LINKED_FILES
set :linked_dirs, fetch(:linked_dirs, []) + LINKED_DIRS

set :rbenv_type, :user
set :rbenv_ruby, '3.3.0'
set :rails_env, 'production'
set :keep_releases, 2
set :local_user, deploy_user
set :assets_roles, [:app]

namespace :deploy do
  before  :compile_assets, :clobber_assets
end

# namespace :deploy do
#   desc "Make sure local git is in sync with remote."
#   task :check_revision do
#     on roles(:app) do
#       unless `git rev-parse HEAD` == `git rev-parse origin/master`
#         puts "WARNING: HEAD is not the same as origin/master"
#         puts "Run `git push` to sync changes."
#         exit
#       end
#     end
#   end
#   desc 'Initial Deploy'
#   task :initial do
#     on roles(:app) do
#       before 'deploy:restart', 'puma:start', 'sidekiq:restart'
#       invoke 'deploy'
#     end
#   end
#   desc 'Restart application'
#   task :restart do
#     on roles(:app), in: :sequence, wait: 5 do
#       invoke 'puma:restart'
#     end
#   end
#   before :starting,     :check_revision
#   after  :finishing,    :cleanup
# end

# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
