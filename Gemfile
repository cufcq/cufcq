source 'https://rubygems.org'
ruby '1.9.3'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'
# gem 'bootstrap-sass', '2.3.2.0'
# Use sqlite3 as the database for Active Record
group :development do
  gem 'debugger', group: [:development, :test]
  gem 'database_cleaner'
  gem 'launchy'
  gem 'rspec-rails'
  gem 'progress_bar'
  gem 'eventmachine'
end



gem 'taps'
# Sunspot solr Search
gem 'sunspot_rails', '2.2.0'
gem 'sunspot_solr', '2.2.0'


# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'


# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'


# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# gem 'jquery-turbolinks'

gem 'will_paginate', '~> 3.0.6'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'pg'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# # Use Capistrano for deployment
# gem 'capistrano', group: :development
# # gem 'activerecord-postgres-hstore'
#
# group :development do
#   gem 'capistrano-rails'
#   gem 'capistrano-rbenv', '~> 2.0', require: false
# end

group :production do
  gem 'thin'
end

group :test do
  gem 'minitest-spec-rails'
end
