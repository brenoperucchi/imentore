default_run_options[:pty] = true
set :application, "imentore"
set :repository,  "git@github.com:bperucchi/imentore.git"
set :applicationdir, "/home/imentore/app/current/imentore-base"

set :scm, :git
# set :scm_passphrase, "aszx12qw"  # The deploy user's password
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user, "imentore"  # The server's user for deploys
set :use_sudo, false
set :deploy_to, "/home/imentore/app"
# set :deploy_via, :remote_cache
set :branch, "master"

 
role :web, "216.120.250.136"                          # Your HTTP server, Apache/etc
role :app, "216.120.250.136"                          # This may be the same as your `Web` server
role :db,  "216.120.250.136", :primary => true # This is where Rails migrations will run
ssh_options[:keys] = "#{ENV['HOME']}/.ssh/216.120.250.136/imentore"
ssh_options[:auth_methods] = %w(publickey)

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:

# after "deploy", "deploy:bundle_gems"
# after "deploy:bundle_gems", "deploy:restart"

after "deploy", "deploy:config_files"

namespace :deploy dodu -hls -
  task :bundle_gems do
    run "cd #{deploy_to}/current/imentore-base && bundle install"
  end

  task :config_files do
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
  end
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
