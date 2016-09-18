ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'factory_girl'
FactoryGirl.find_definitions
include FactoryGirl::Syntax::Methods
