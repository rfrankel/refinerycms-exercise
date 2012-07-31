set :application, "randr"
set :repository,  "https://github.com/rfrankel/refinerycms-exercise.git"

set :scm, :git
set :user, "deploy"
set :deploy_to, "/home/deploy/apps/#{application}"

set :use_sudo, false
set :keep_releases, 5

role :web, 50.116.53.19                         # Your HTTP server, Apache/etc
role :app, 50.116.53.19                          # This may be the same as your `Web` server
role :db,  50.116.53.19, :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end

# Stuff for managing database.yml 
# Following advice in:
# http://www.tigraine.at/2011/09/25/securely-managing-database-yml-when-deploying-with-capistrano/

namespace :db do
  task :db_config, :except => { :no_release => true }, :role => :app do
    run "cp -f ~/database.yml #{release_path}/config/database.yml"
  end
end

after "deploy:finalize_update", "db:db_config"