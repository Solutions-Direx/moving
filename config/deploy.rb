ssh_options[:forward_agent] = true
default_run_options[:pty] = true
require 'bundler/capistrano'

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

##### SETTINGS #####
set :application, ""

set :scm, :git
set :repository,  "git@github.com:olimart/moving.git"
set :deploy_via, :remote_cache
set :branch, 'master' 
set :scm_commnand, '/usr/bin/git'
set :local_scm_command, 'git'

set :user, 'maximil2'
set :use_sudo, true

set :base_path, #"/home/"
set :deploy_to, #"/home/"

role :web, ""                          # Your HTTP server, Apache/etc
role :app, ""                          # This may be the same as your `Web` server
role :db,  "", :primary => true # This is where Rails migrations will run
####################

##### STRATEGY #####
after "deploy:setup", "init:set_permissions"
after "deploy:setup", "init:database_yaml"
after "deploy:setup", "init:production_file"

before "deploy:finalize_update", "config:symlink_shared_configurations"
before "deploy:finalize_update", "config:symlink_production_file"
after "deploy", "deploy:cleanup" # keeps only last 5 releases
####################

###### TASKS #######
namespace :deploy do
  task :start do ; end
  task :stop  do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path, "tmp/restart.txt")}"
  end
end

namespace :rake_tasks do
  task :bootstrap_db, :roles => :app do
    run "cd #{release_path}; bundle exec rake RAILS_ENV=#{rails_env} -f #{release_path}/Rakefile db:drop db:migrate db:seed --trace"
  end
end

namespace :config do
  desc "Symlink shared configuration to current release"
  task :symlink_shared_configurations, :roles => [:app] do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end
  
  desc "Symlink production file to current release"
  task :symlink_production_file, :roles => [:app] do
    run "rm #{release_path}/config/environments/production.rb"
    run "ln -nfs #{shared_path}/config/production.rb #{release_path}/config/environments/production.rb" 
  end
  
end

namespace :init do
  
  desc "Set proper permissions for deployment user"
  task :set_permissions do
    sudo "chown -R #{user}:#{user} #{base_path}"
  end
  
  desc "Create database yaml" 
  task :database_yaml do
    set :db_name, Capistrano::CLI.ui.ask("database name: ")
    set :db_user, Capistrano::CLI.ui.ask("database user: ")
    set :db_password, Capistrano::CLI.password_prompt("database password: ")
    db_config = ERB.new <<EOF
production:
  adapter: pg
  encoding: utf8
  username: #{db_user}
  password: #{db_password}
  database: #{db_name}
EOF
    
    run "mkdir -p #{shared_path}/config"
    put db_config.result, "#{shared_path}/config/database.yml"
  end
  
  desc "Create production.rb"
  task :production_file do
    template = ERB.new(File.read('config/production.rb.erb'))
    # mail server
    mail_server_address = Capistrano::CLI.ui.ask('What is mail server address ("smtp.domain.com")?: ')
    mail_server_post = Capistrano::CLI.ui.ask('What is mail server port (587)?: ')
    mail_server_auth = Capistrano::CLI.ui.ask('What is mail server authentication method (plain)?: ')
    mail_server_username = Capistrano::CLI.ui.ask('What is mail server username?: ')
    mail_server_password = Capistrano::CLI.ui.ask('What is mail server password?: ')
    mail_server_domain = Capistrano::CLI.ui.ask('What is mail server domain?: ')
    mail_server_starttls = Capistrano::CLI.ui.ask('Is starttls_auto enabled (true|false)?: ')
    
    run "mkdir -p #{shared_path}/config"
    put template.result(binding), "#{shared_path}/config/production.rb" 
  end
end

namespace :db do
  desc "Migrate database"
  task :migrate, :roles => :app do
    run "cd #{current_path}; bundle exec rake RAILS_ENV=production -f #{current_path}/Rakefile db:migrate --trace"
  end
  
  desc "Seed database"
  task :seed, :roles => :app do
    run "cd #{current_path}; bundle exec rake RAILS_ENV=production -f #{current_path}/Rakefile db:seed --trace"
  end
  
  desc "Drop & Migrate database"
  task :reset, :roles => :app do
    run "cd #{current_path}; bundle exec rake RAILS_ENV=production -f #{current_path}/Rakefile db:drop db:migrate --trace"
  end
end