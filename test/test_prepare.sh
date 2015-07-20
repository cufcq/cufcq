#!/bin/bash

# test_prepare : file needs to be run once for all unit tests to operate properly
# seeds and prepares the test database

export RAILS_ENV=test
#kill solr process
pkill -f solr
#remove old data
rm -rf solr/data
rm -rf solr/default
rm -rf solr/development
rm -rf solr/pids
rm -rf solr/test
#startup solr in development environment
rake sunspot:solr:start
# meat n potatoes right here
rake db:test:prepare
rake db:seed
