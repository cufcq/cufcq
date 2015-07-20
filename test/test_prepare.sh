#!/bin/bash

# test_prepare : file needs to be run once for all unit tests to operate properly
# seeds and prepares the test database

#kill solr process
pkill -f solr
#remove old data
rm -rf solr/data
rm -rf solr/default
rm -rf solr/development
rm -rf solr/pids
rm -rf solr/test
#startup solr in development environment
rake RAILS_ENV=test sunspot:solr:start
# meat n potatoes right here
rake db:test:prepare
rake RAILS_ENV=test db:seed
