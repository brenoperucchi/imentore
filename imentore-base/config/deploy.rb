SSHKit.config.command_map[:rake] = "bundle exec rake --gemfile /home/imentore/app/current/imentore-base/Gemfile"
# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'imentore'
set :repo_url, 'git@github.com:bperucchi/imentore.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
set :branch, "master"

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/imentore/app'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, true

# set :bundle_path, -> { '/home/imentore/app/imentore-base' }      # this is default

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

set :user, "imentore"
set :branch, "master"



# config/deploy.rb
# set :bundle_gemfile,  "#{current_path}/imentore-base/Gemfile"
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '1.9.3-p547'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

namespace :setup do
  desc "Symlinks config files for Nginx and Unicorn."
  task :symlink_config do
    on roles(:app) do
      # execute "rm -f /etc/nginx/sites-enabled/default"
      execute "ln -nfs #{current_path}/imentore-base/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}"
      execute "ln -nfs #{current_path}/imentore-base/config/unicorn_init.sh /etc/init.d/unicorn_#{fetch(:application)}"
   end
  end
end

namespace :deploy do

  # desc 'Restart application'
  # task :restart do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     execute "/etc/init.d/unicorn restart"
  #     # execute "/etc/init.d/unicorn start"
  #   end
  # end
  # task :start do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     execute "/etc/init.d/unicorn start"
  #   end
  # end
  # task :stop do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     execute "/etc/init.d/unicorn stop"
  #   end
  # end
  # task :bundle do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     execute "cd /home/imentore/app/current/imentore-base && bundle install "
  #   end
  # end

  desc "Makes sure local git is in sync with remote."
  task :check_revision do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} Unicorn server."
    task command do
      on roles(:app) do
        execute "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
      end
    end
  end
  before :deploy, "deploy:check_revision"
  after :deploy, "deploy:restart"
  after :rollback, "deploy:restart"

  # task :imentore_config_files do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     execute "rm -rf /home/imentore/app/current/imentore-base/tmp"
  #     execute "rm -rf /home/imentore/app/current/imentore-base/log"
  #     execute "mkdir /home/imentore/app/current/imentore-base/tmp"
  #     execute "rm -rf /home/imentore/app/current/imentore-base/public/uploads"
  #     execute "ln -s /home/imentore/app/shared/uploads /home/imentore/app/current/imentore-base/public/uploads"
  #     execute "ln -s /home/imentore/app/shared/pids /home/imentore/app/current/imentore-base/tmp/pids"
  #     execute "ln -s /home/imentore/app/shared/cache /home/imentore/app/current/imentore-base/tmp/cache"
  #     execute "ln -s /home/imentore/app/shared/log /home/imentore/app/current/imentore-base/log"
  #     execute "ln -s /home/imentore/app/shared /home/imentore/app/current/tmp"

  #     execute "chown -h imentore.imentore /home/imentore/app/current/imentore-base/public/uploads"
  #     execute "chown -h imentore.imentore /home/imentore/app/current/imentore-base/tmp/pids"
  #     execute "chown -h imentore.imentore /home/imentore/app/current/imentore-base/tmp/cache"
  #     execute "chown -h imentore.imentore /home/imentore/app/current/imentore-base/log"
  #     execute "chown -h imentore.imentore /home/imentore/app/current/tmp"
  #     execute "cp -f /home/imentore/app/shared/database.yml /home/imentore/app/current/imentore-base/config/database.yml"
  #   end
  # end  

  # after :publishing, :imentore_config_files
  # after :finishing, :restart
  # # after :finishing, :start

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end

end
