#!/bin/bash
ps -ef | grep solr | grep -v grep | awk '{print $2}' | xargs kill -9
ps aux | grep solr
RAILS_ENV=development bundle exec rake sunspot:solr:start
RAILS_ENV=development bundle exec rake sunspot:solr:reindex
rails s
echo "rails server closed!"
