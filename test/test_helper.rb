ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
include FactoryGirl::Syntax::Methods

module ActiveSupport
  class TestCase
  end
end
