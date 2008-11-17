set :application, "filo"
set :repository, "http://matteo.textdriven.com/svn/#{application}/trunk"
set :deploy_to, "/accounts/mvaccari/rails/filo"
set :user, "mvaccari"
set :use_sudo, false
set :keep_releases, 2
ssh_options[:port] = 2217

role :web, "storm.unbit.it"
role :app, "storm.unbit.it"
role :db,  "storm.unbit.it", :primary => true

desc "Restart the web server"
namespace :deploy do
  task :restart, :roles => :app do
    run "killall -USR1 ruby"
  end
end