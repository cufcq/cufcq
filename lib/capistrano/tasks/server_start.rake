namespace :deploy do
  desc 'Test deployment'
      task :test do 
         on roles(:app)  do
          execute "echo test"
        end
      end   
end

namespace :deploy do
  desc 'Run total reload'
    task :total_relaod do 
        on roles(:app)  do
            execute "pwd"
            execute "./total_reload.sh"
        end
    end
end 

namespace :deploy do 
    desc 'Setup our server'
      task :setup_cufcq do 
        on roles(:app) do 
            execute "echo 'THIS IS WHERE OUR PUPPET SCRIPT goes'"
        end
      end
end
