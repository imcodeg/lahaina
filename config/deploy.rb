default_run_options[:pty] = true
set :application, "lahaina"
set :repository,  "git@github.com:robconery/lahaina.git"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :scm, :git

ssh_options[:forward_agent] = true

set :deploy_to, "/home/rob/www/lahaina"

role :web, "sudofactory.com"                          # Your HTTP server, Apache/etc
role :app, "sudofactory.com"                          # This may be the same as your `Web` server
role :db,  "sudofactory.com", :primary => true        # This is where Rails migrations will run

after "deploy:symlink","customs:symlink"
after "deploy", "deploy:cleanup"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end
 namespace(:customs) do
   task :symlink, :roles => :app do
     run <<-CMD
       ln -nfs #{shared_path}/system/uploads #{release_path}/public/uploads
     CMD
     run <<-CMD
       ln -nfs #{shared_path}/wp-content #{release_path}/public/wp-content
     CMD
     run <<-CMD
       ln -nfs #{shared_path}/Content #{release_path}/public/Content
     CMD
     run <<-CMD
       ln -nfs #{shared_path}/files #{release_path}/public/files
     CMD
     
   end
 end