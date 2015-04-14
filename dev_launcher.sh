#!/bin/bash



#Use this for running cufcq on the dev server 

echo "I SHOULD BE RUNNING ON THE DEV SERVER"
echo "Starting/Reindexing Solr"

pkill -f server 

rake sunspot:solr:start RAILS_ENV=development
rake sunspot:solr:reindex RAILS_ENV=development

echo "Solr successful! Starting Rails" 

rails server -b 0.0.0.0 -p 80 -d &

