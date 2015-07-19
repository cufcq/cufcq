#!/bin/bash

echo "FOR USE ON THE PRODUCTION SERVER"
echo "starting passenger"

# passenger start -a 0.0.0.0 -p 80
#TODO in future, setup production
passenger start -a 0.0.0.0 -p 80 -e production

echo "rails server closed!"
