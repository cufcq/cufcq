#!/bin/bash

echo "Starting/Reindexing Solr"
rake sunspot:solr:start RAILS_ENV=development
rake sunspot:solr:reindex RAILS_ENV=development

echo "Solr successful! Starting Rails" 

rails server -b 0.0.0.0 -p 80
echo "rails server closed!"
