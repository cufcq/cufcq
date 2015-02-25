#!/bin/bash

#kill solr process
pkill -f solr

#remove old data
rm -rf solr/data
rm -rf solr/default
rm -rf solr/development
rm -rf solr/pids
rm -rf solr/test

#startup solr in development environment
rake sunspot:solr:start RAILS_ENV=development

#all of our rake tasks
bundle exec rake db:reset
bundle exec rake db:migrate
bundle exec rake departments
bundle exec rake import
bundle exec rake recitation_correction
bundle exec rake ic_relations
bundle exec rake grades

#reindex solr 
RAILS_ENV=development bundle exec rake sunspot:solr:reindex
