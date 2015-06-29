######Capistrano Test#######
set :user, 'root'
set :application, 'cufcq'
set :scm, :git
#do we need the .git link?
set :repo_url, 'https://github.com/cufcq/cufcq.git'
set :branch, 'master'
set :deploy_to, "/root/cufcq_deploy"
set :deploy_via, :copy
set :rails_env, "development"
#set :rbenv_ruby, '1.9.3-p551'
###########################

namespace :deploy do
desc 'Total Reload'
  task :total_reload do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{deploy_to}/current && nohup ./total_reload.sh &"
    end
  end
end


namespace :deploy do
desc 'Start dev server'
  task :dev_start do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{deploy_to}/current && ./dev_launcher.sh "  ## -> line you should add
    end
  end
end

task :prepare_bundle_config do
  on roles(:app), in: :sequence, wait: 5 do
    #execute "echo TEST"
    execute "bundle config build.pg --with-pg-config=/usr/lib/postgresql/9.3/bin/pg_config"
  end
end

before 'bundler:install', 'prepare_bundle_config'
#bundle config build.pg --with-pg-config=/usr/lib/postgresql/9.3/bin/pg_config

#TEST
# TEst class
