#!/bin/bash
rake db:test:prepare
rake RAILS_ENV=test db:seed
