ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
require 'coveralls'
SimpleCov.formatters = [Coveralls::SimpleCov::Formatter,
                       SimpleCov::Formatter::HTMLFormatter]
SimpleCov.start 'rails' do
  add_filter do |source_file|
    source_file.lines.count < 5
  end

  # The dev is too lazy to test these legacy stuff
  add_filter '/app/controllers/line_controller.rb'
  add_filter '/app/controllers/travis_controller.rb'
  add_filter '/app/tasks/dump_kto_hasil.rb'
  add_filter 'app/tasks/line_nag.rb'
end

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'capybara/rails'
TransactionalCapybara.share_connection

FileUtils.rm_rf(Rails.root.join('coverage'))

Rails.application.load_seed

module ActiveSupport
  class TestCase
    require 'factory_girl'
    include FactoryGirl::Syntax::Methods

    def teardown
      FileUtils.rm_rf(Rails.root.join('public', 'contest_files'))
    end

    private

    def login_and_be_admin
      @user = create(:user)
      @user.add_role :panitia
      @user.add_role :admin
      @request.cookies[:auth_token] = @user.auth_token
    end

    def test_abilities(model_object, method, bad_roles, good_roles)
      good_roles.each do |r|
        user = create(:user, role: r)
        ability = Ability.new user
        assert ability.can?(method, model_object),
               "#{r} cannot #{method} on #{model_object}."
      end

      bad_roles.each do |r|
        user = create(:user, role: r)
        ability = Ability.new user
        assert ability.cannot?(method, model_object),
               "#{r} can #{method} on #{model_object}."
      end
    end
  end
end

module ActionDispatch
  class IntegrationTest
    # Make the Capybara DSL available in all integration tests
    include Capybara::DSL

    url = "#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}" \
    '@localhost:4445/wd/hub'
    Capybara.register_driver :sauce do |app|
      Capybara::Selenium::Driver.new(app, browser: :remote, url: url)
    end
    Capybara.default_driver = ENV['TRAVIS'] ? :sauce : :selenium

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
