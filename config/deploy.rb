# rbenv path
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

require "bundler/capistrano"
set :bundle_flags, "--deployment --quiet --binstubs"

set :application, "js.co.tt" # You should probably change this to something more meaningful to you, but you don't have to.
set :repository,  "git@github.com:scotje/jscott-newton.git" # This should point at your forked repo.

set :scm, :git
set :git_enable_submodules, 1
set :branch, "master" # Change this if you have a different branch for deployment in your repo.
set :deploy_via, :remote_cache # You can change this if you prefer something else.

# You should change these to appropriate values for your server.
set :user, "admin"
set :use_sudo, false
set :deploy_to, "/home/apps/#{application}"


role :web, "banshee.vanisher.net"
role :app, "banshee.vanisher.net"
role :db,  "banshee.vanisher.net", :primary => true

after "deploy:update_code", :symlink_db
after "deploy:restart", "deploy:cleanup"


task :symlink_db do
  run "#{try_sudo} /bin/ln -sf #{shared_path}/production.sqlite3 #{release_path}/db/production.sqlite3"
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}" # This works for Passenger powered deploys, you'll need to change this if you use a different stack.
  end
end
