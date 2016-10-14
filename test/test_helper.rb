ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

FileUtils.rm_rf(Rails.root.join('coverage'))

module ActiveSupport
  class TestCase
    require 'factory_girl'
    include FactoryGirl::Syntax::Methods

    def teardown
      FileUtils.rm_rf(Rails.root.join('public', 'contest_files'))
    end
  end
end

require_relative 'support'
