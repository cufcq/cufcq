#!/bin/bash

echo "Starting/Reindexing Solr"
echo "Solr successful! Starting Rails" 

rails server -b 0.0.0.0 -p 80
echo "rails server closed!"
