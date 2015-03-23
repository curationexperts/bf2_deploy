# config valid only for Capistrano 3.1
lock '3.4.0'

set :application, 'bf2_deploy'
set :repo_url, 'git@github.com:curationexperts/bf2_deploy.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/opt/folders'
set :scm, :git
set :format, :pretty
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml config/solr.yml config/initializers/blacklight_initializer.rb config/initializers/devise.rb}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  before :compile_assets, :clobber_assets do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
         execute :rake, 'assets:clobber'
       end
    end
  end

end
