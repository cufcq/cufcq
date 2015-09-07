#!/bin/bash

#Use this for running cufcq locally
echo "DEVELOPMENT MODE"

./solr_start.sh -d

echo "Solr successful! Starting Rails"

rails server -b localhost -p 3000
echo "rails server closed!"
