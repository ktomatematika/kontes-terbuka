ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

module ActiveSupport
  class TestCase
    require 'factory_girl'
    FactoryGirl.find_definitions
    include FactoryGirl::Syntax::Methods
  end
end

pdf = File.open(Rails.root.join('test', 'support', 'a.pdf'), 'r')
tex = File.open(Rails.root.join('test', 'support', 'a.tex'), 'r')
