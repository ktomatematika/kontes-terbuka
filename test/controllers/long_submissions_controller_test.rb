require 'test_helper'

class LongSubmissionsControllerTest < ActionController::TestCase
	test "should get create" do
		get :create
		assert_response :success
	end

	test "should get destroy" do
		get :destroy
		assert_response :success
	end

	# create should redirect to contest_path
	# create should successfully done
	# destroy too
	# create should fail on missing params
end
