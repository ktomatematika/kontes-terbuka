# frozen_string_literal: true

require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test 'routes' do
    assert_equal root_path, '/'
    assert_equal sign_users_path, '/users/sign'
  end

  test 'index' do
    login_and_be_admin
    get :index
    assert_redirected_to home_path
  end

  test 'index with no user' do
    get :index
    assert_response 200
  end

  test 'sign' do
    get :sign
    assert_response 200
  end
end
