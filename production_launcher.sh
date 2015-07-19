#!/bin/bash

echo "FOR USE ON THE PRODUCTION SERVER"

# RAILS_ENV=production rake sunspot:solr:start
RAILS_ENV=production rake sunspot:solr:reindex
rake assets:precompile


echo "starting passenger"

# passenger start -a 0.0.0.0 -p 80
#TODO in future, setup production
sudo passenger start -a 0.0.0.0 -p 80 -e production

echo "rails server closed!"
