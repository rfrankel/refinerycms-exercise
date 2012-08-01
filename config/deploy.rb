# OK, following Mauricio Linhares advice:
require "rvm/capistrano"
# and since it complained about the ruby string:
set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"") # Read from local system

# RVM bootstrap
# apparently no longer necessary --- 
# now add rvm-capistrano to gemfile instead 
# $:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# OK, nothing is working. Trying having Capistrano
# install rvm and ruby for me,  
before 'deploy:setup', 'rvm:install_rvm'
set :rvm_install_type, :stable

before 'deploy:setup', 'rvm:install_ruby'
set :rvm_install_ruby, :install

# Following directions in: 
# https://rvm.io//integration/capistrano/
# require "rvm/capistrano"
# set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"") # Read from local system

# bundler bootstrap
require 'bundler/capistrano'

# main capistrano config 
set :application, "randr"
set :repository,  "https://github.com/rfrankel/refinerycms-exercise.git"

set :scm, :git
set :user, "deploy"
set :deploy_to, "/home/deploy/apps/#{application}"

set :use_sudo, false
set :keep_releases, 5

role :web, "rebeccafrankel.com"                         # Your HTTP server, Apache/etc
role :app, "rebeccafrankel.com"                          # This may be the same as your `Web` server
role :db,  "rebeccafrankel.com", :primary => true # This is where Rails migrations will run

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
