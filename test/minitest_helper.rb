ENV['RAILS_ENV'] = 'test'
require 'rake'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# alteration to array class
class Array

  def average_hash(key)
    map { |x| x[key].to_f }.inject(:+) / length
  end

end
