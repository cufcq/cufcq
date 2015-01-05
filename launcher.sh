#!/bin/bash
rvmsudo rails server thin -p 80 &
echo "rails server launched!"
