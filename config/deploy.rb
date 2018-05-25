# config valid for current version and patch releases of Capistrano
lock "~> 3.10.2"

set :application, "snek"
set :repo_url, "git@github.com:noff/snek.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/rails/#{fetch(:application)}"

set :deploy_via,      :remote_cache
set :ssh_options,     {forward_agent: true}
set :use_sudo,        false
set :keep_releases, 10

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/unicorn.rb', 'config/master.key', 'config/database.yml'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", 'vendor/bundle'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

after 'deploy:restart', 'sidekiq:restart'

set :rvm_type, :user
set :rvm_ruby_version, '2.3.1'
set :assets_roles, [:web, :app]
after 'deploy:publishing', 'deploy:restart'

namespace :deploy do

  desc 'Start unicorn'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{current_path}; ~/.rvm/bin/rvm default do bundle exec unicorn -c config/unicorn.rb -E #{fetch :rails_env} -D"
    end
  end

  desc 'Stop unicorn'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      execute "kill -s QUIT `cat #{shared_path}/tmp/pids/unicorn.pid`"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "kill -s USR2 `cat #{shared_path}/tmp/pids/unicorn.pid`"
    end
  end

end