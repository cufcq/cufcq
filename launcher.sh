#!/bin/bash

echo "Starting/Reindexing Solr"
rake sunspot:solr:start RAILS_ENV=development
rake sunspot:solr:reindex RAILS_ENV=development

echo "Solr successful! Starting Rails" 

rails s
echo "rails server closed!"
