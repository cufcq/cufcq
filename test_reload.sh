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
# bundle exec rake recitation_correction
bundle exec rake course_titles
bundle exec rake ic_relations
bundle exec rake grades
# build the hstore for departments

bundle exec rake instructor_build_hstore
bundle exec rake course_build_hstore
bundle exec rake department_build_hstore

# these rake tasks make slight corrections to the dataset. They should run pretty darn fast
bundle exec rake course_names
bundle exec rake course_missing_hstore

#make the slugs for nice urls
bundle exec rake course_slugs
bundle exec rake instructor_slugs
bundle exec rake department_slugs

#reindex solr 
RAILS_ENV=development bundle exec rake sunspot:solr:reindex
