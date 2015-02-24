#!/bin/bash
ps -ef | grep solr | grep -v grep | awk '{print $2}' | xargs

#to confirm solr is killed·
ps aux | grep solr

rm solr/pids/production/sunspot-solr-production.pid

#This does a total reload, it includes all of the populate tasks. 
#See lib/tasks/import.rake for more info
pkill -f solr
rake sunspot:solr:start RAILS_ENV=development

bundle exec rake db:reset
bundle exec rake db:migrate
bundle exec rake departments
bundle exec rake import
# bundle exec rake instructor_populate
# bundle exec rake course_populate
# bundle exec rake department_populate
bundle exec rake recitation_correction
bundle exec rake ic_relations
bundle exec rake grades
RAILS_ENV=development bundle exec rake sunspot:solr:reindex