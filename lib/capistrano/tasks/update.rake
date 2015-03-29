require 'rake'

namespace :rake do
  desc "Test echo."
  task :test do
    #run("cd #{deploy_to}/current; /usr/bin/env rake #{ENV['task']} RAILS_ENV=#{rails_env}")  
    run("echo TEST")
  end   
end
