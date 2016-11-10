require 'test_helper'

class LineControllerTest < ActionController::TestCase
  test 'routes' do
    assert_equal line_bot_path, '/line-bot'
  end
end
