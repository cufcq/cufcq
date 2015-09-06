#!/bin/bash

echo "FOR USE ON THE PRODUCTION SERVER"

rake assets:precompile

./solr_start.sh -p

echo "starting passenger"
sudo passenger start -a 0.0.0.0 -p 80 -e production -d

echo "production server closed!"
