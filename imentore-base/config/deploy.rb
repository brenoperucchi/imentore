# config valid only for Capistrano 3.1
lock '3.1.0'

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

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      run "/etc/init.d/unicorn restart"
    end
  end

  after :restart, :app_config_files do
    on roles(:app), in: :sequence, wait: 5 do
      run "rm -rf /home/imentore/app/current/imentore-base/tmp"
      run "rm -rf /home/imentore/app/current/imentore-base/log"
      run "mkdir /home/imentore/app/current/imentore-base/tmp"
      run "rm -rf /home/imentore/app/current/imentore-base/public/uploads"
      run "ln -s /home/imentore/app/shared/uploads /home/imentore/app/current/imentore-base/public/uploads"
      run "ln -s /home/imentore/app/shared/pids /home/imentore/app/current/imentore-base/tmp/pids"
      run "ln -s /home/imentore/app/shared/cache /home/imentore/app/current/imentore-base/tmp/cache"
      run "ln -s /home/imentore/app/shared/log /home/imentore/app/current/imentore-base/log"
      run "ln -s /home/imentore/app/shared /home/imentore/app/current/tmp"

      run "chown -h imentore.imentore /home/imentore/app/current/imentore-base/public/uploads"
      run "chown -h imentore.imentore /home/imentore/app/current/imentore-base/tmp/pids"
      run "chown -h imentore.imentore /home/imentore/app/current/imentore-base/tmp/cache"
      run "chown -h imentore.imentore /home/imentore/app/current/imentore-base/log"
      run "chown -h imentore.imentore /home/imentore/app/current/tmp"
      run "cp -f /home/imentore/app/shared/database.yml /home/imentore/app/current/imentore-base/config/database.yml"
    end
  end  

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
