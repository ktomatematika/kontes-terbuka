require 'test_helper'

class TravisControllerTest < ActionController::TestCase
  test 'routes' do
    assert_equal travis_path, '/travis'
  end
end
