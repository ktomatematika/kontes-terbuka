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

    private

    def login_and_be_admin
      @user = create(:user)
      @user.add_role :panitia
      @user.add_role :admin
      @request.cookies[:auth_token] = @user.auth_token
    end

    def test_abilities(model_object, method, bad_roles, good_roles)
      user = create(:user)
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

require_relative 'support'
