#!/bin/bash

#This does a total reload, it includes all of the populate tasks. 
#See lib/tasks/import.rake for more info
pkill -f solr
RAILS_ENV=development bundle exec rake sunspot:solr:start

bundle exec rake db:reset
bundle exec rake db:migrate
bundle exec rake import
bundle exec rake instructor_populate
bundle exec rake course_populate
bundle exec rake department_populate

bundle exec rake recitation_correction
bundle exec rake ic_relations
bundle exec rake set_department_name
RAILS_ENV=development bundle exec rake sunspot:solr:reindex