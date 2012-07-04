default_run_options[:pty] = true
set :application, "imentore"
set :repository,  "git@github.com:bperucchi/imentore.git"
set :applicationdir, "/home/imentore/app"

set :scm, :git
# set :scm_passphrase, "aszx12qw"  # The deploy user's password
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user, "imentore"  # The server's user for deploys
set :use_sudo, false
set :deploy_to, "/home/imentore/app"
set :deploy_via, :remote_cache
set :branch, "master"

 
role :web, "216.224.180.236"                          # Your HTTP server, Apache/etc
role :app, "216.224.180.236"                          # This may be the same as your `Web` server
role :db,  "216.224.180.236", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:

# after "deploy", "deploy:bundle_gems"
# after "deploy:bundle_gems", "deploy:restart"

namespace :deploy do
  task :bundle_gems do
    run "cd #{deploy_to}/current/imentore-base && bundle install"
  end
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
