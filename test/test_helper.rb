ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

FileUtils.rm_rf(Rails.root.join('coverage'))

Rails.application.load_seed

module ActiveSupport
  class TestCase
    require 'factory_girl'
    include FactoryGirl::Syntax::Methods

    def teardown
      FileUtils.rm_rf(Rails.root.join('public', 'contest_files'))
    end

    protected

    def login
      @user = create(:user)
      @request.cookies[:auth_token] = @user.auth_token
    end

    def promote(*roles)
      roles.each { |r| @user.add_role r }
    rescue StandardError
      @user.add_role :panitia
      retry
    end
  end
end

require_relative 'support'
