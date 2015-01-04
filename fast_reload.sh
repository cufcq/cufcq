#!/bin/bash

#This is a faster version of total_reload. It doesn't perfrom any population and should be used after making changes to the DB.
#See lib/tasks/import.rake for more info

bundle exec rake db:reset
bundle exec rake db:migrate
bundle exec rake import
#bundle exec rake instructor_populate
#bundle exec rake course_populate
#bundle exec rake department_populate
bundle exec rake recitation_correction
#bundle exec rake ic_relations
bundle exec rake set_department_name
bundle exec rake sunspot:reindex

