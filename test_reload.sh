#!/bin/bash
mv data/fcq/ data/fcq_temp/
mkdir data/fcq
shuf -n 20 data/fcq_temp/1-2012_7-2014.csv > data/fcq/test.csv
echo "Initialized Test Data, starting total_reload"

./total_reload.sh -d

rm -rf data/fcq
mv data/fcq_temp data/fcq
echo "Finished Initializing DB, Running Tests"
rake test
echo "Success"
