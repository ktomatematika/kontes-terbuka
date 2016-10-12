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

PDF = File.open(Rails.root.join('test', 'support', 'a.pdf'), 'r')
TEX = File.open(Rails.root.join('test', 'support', 'a.tex'), 'r')
