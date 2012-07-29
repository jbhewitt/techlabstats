#require ‘bundler/capistrano’


set :application, "techlabstats"


set :scm, "git"
set :repository, "https://github.com/jbhewitt/techlabstats.git"
set :branch, "master"

set :rvm_type, :user
set :rvm_ruby_string, '1.9.3'
 
role :web, "apps.stcpl.com.au"                          # Your HTTP server, Apache/etc
role :app, "apps.stcpl.com.au"                          # This may be the same as your `Web` server
role :db,  "apps.stcpl.com.au", :primary => true # This is where Rails migrations will run


set :user, "deploy"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false


default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:compression] = "none"



# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end