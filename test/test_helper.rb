ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

module ActiveSupport
  class TestCase
    require 'factory_girl'
    include FactoryGirl::Syntax::Methods
  end
end

require_relative 'support'
