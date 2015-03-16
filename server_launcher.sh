#!/bin/bash

echo "starting passenger"

passenger start -a 0.0.0.0 -p 80
#TODO in future, setup production
#passenger start -a 0.0.0.0 -p 80 -d -e production


echo "rails server closed!"
