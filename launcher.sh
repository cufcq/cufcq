#!/bin/bash
ps -ef | grep solr | grep -v grep | awk '{print $2}' | xargs kill -9

#to confirm solr is killed 
ps aux | grep solr

rm solr/pids/production/sunspot-solr-production.pid

# start the server in the development environement 
# WARNING: when launching on a production server, MANUALLY specifiy the production env. 

#http://stackoverflow.com/questions/7305709/ruby-on-rails-solr-sunspot-connection-refused-connect2

rake sunspot:solr:start RAILS_ENV=development
rake sunspot:solr:reindex RAILS_ENV=development

#rails s
echo "rails server closed!"
