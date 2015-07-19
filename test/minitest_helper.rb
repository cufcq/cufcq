ENV['RAILS_ENV'] = 'test'
require 'rake'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'

# task :prepare => :environment do
#   Rake::Task["db:reset"].invoke
#   Rake::Task["db:test:prepare"].invoke
#   Rake::Task["db:migrate"].invoke
#   Rake::Task["db:seed"].invoke
# end

# alteration to array class
class Array

  def average_hash(key)
    map { |x| x[key].to_f }.inject(:+) / length
  end

end
# class ActiveSupport::TestCase
#   setup :load_seeds
#   def load_seeds
#     puts 'loading insanity'
#     load "#{Rails.root}/db/seeds.rb"
#   end
# end
