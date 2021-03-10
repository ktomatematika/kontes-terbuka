# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'

require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'

require 'capybara/rails'
TransactionalCapybara.share_connection

FileUtils.rm_rf(Rails.root.join('coverage'))

Rails.application.load_seed

module ActiveSupport
  class TestCase
    require 'factory_bot'
    include FactoryBot::Syntax::Methods

    def teardown
      FileUtils.rm_rf(Rails.root.join('public', 'contest_files'))
    end

    private def login_and_be_admin
      @user = create(:user)
      @user.add_role :panitia
      @user.add_role :admin
      @request.cookies[:auth_token] = @user.auth_token
    end

    private def test_abilities(model_object, method, bad_roles, good_roles)
      bad_roles.each do |r|
        user = r.is_a?(User) ? r : create(:user, role: r)
        ability = Ability.new user
        assert ability.cannot?(method, model_object),
               "#{r} can #{method} on #{model_object}."
      end

      good_roles.each do |r|
        user = r.is_a?(User) ? r : create(:user, role: r)
        ability = Ability.new user
        assert ability.can?(method, model_object),
               "#{r} cannot #{method} on #{model_object}."
      end
    end
  end
end

module ActionController
  class TestCase
    def setup
      request.env['HTTP_REFERER'] ||= root_url if request
    end
  end
end

module ActionDispatch
  class IntegrationTest
    # Make the Capybara DSL available in all integration tests
    include Capybara::DSL

    Capybara.default_driver = :selenium

    # Reset sessions and driver between tests
    # Use super wherever this method is redefined in your
    # individual test classes
    def teardown
      TransactionalCapybara::AjaxHelpers.wait_for_ajax(page)
      Capybara.reset_sessions!
      Capybara.use_default_driver
    end
  end
end

require_relative 'support'
