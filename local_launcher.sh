#!/bin/bash

#Use this for running cufcq locally
echo "THIS IS FOR RUNNING ON LOCAL MACHINE"
echo "Starting/Reindexing Solr"

rake sunspot:solr:start RAILS_ENV=development
rake sunspot:solr:reindex RAILS_ENV=development

echo "Solr successful! Starting Rails" 

rails server -b localhost -p 3000
echo "rails server closed!"
