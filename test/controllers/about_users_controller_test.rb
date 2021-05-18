require 'test_helper'

class AboutUsersControllerTest < ActionController::TestCase
  setup :login_and_be_admin, :create_items

  test 'routes' do 
    assert_equal user_about_user_path(@user),
      "/users/#{@user.to_param}/about-user"
    assert_equal edit_user_about_user_path(@user),
      "/users/#{@user.to_param}/about-user/edit"
  end

  test 'create' do
    test_abilities @about_user, :create, [nil], %i[admin]
    # Why can it be that the user.id is nil???
    post :create, user_id: @user.id, about_user: {
      name: 'Test',
      description: 'Test',
      is_alumni: '0',
      image: nil
    }

    # assert_redirected_to user_path(@user)
  end

  test 'edit' do

  end

  test 'update' do
    
  end

  def create_items
    @about_user = build(:about_user)
    @user = @about_user.user
  end
end
