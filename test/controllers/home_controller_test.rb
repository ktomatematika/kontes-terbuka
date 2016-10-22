require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  def setup
    @user = create(:user)
    @request.cookies[:auth_token] = @user.auth_token
  end

  test 'index' do
    assert_equal home_path, '/home'

    get :index
    assert_response 200
  end

  test 'admin' do
    assert_equal admin_path, '/penguasa'

    @user.add_role :panitia
    get :admin
    assert_response 200
  end

  test 'admin without permissions' do
    assert_raises(ActionController::RoutingError) { get :admin }
  end

  test 'about' do
    assert_equal about_path, '/about'

    get :about
    assert_response 200
  end

  test 'book' do
    assert_equal book_path, '/book'

    get :book
    assert_response 200
  end

  test 'contact' do
    assert_equal contact_path, '/contact'

    get :contact
    assert_response 200
  end

  test 'donate' do
    assert_equal donate_path, '/donate'

    get :donate
    assert_response 200
  end

  test 'faq' do
    assert_equal faq_path, '/faq'

    get :faq
    assert_response 200
  end

  test 'privacy' do
    assert_equal privacy_path, '/privacy'

    get :privacy
    assert_response 200
  end

  test 'terms' do
    assert_equal terms_path, '/terms'

    get :terms
    assert_response 200
  end

  test 'masq' do
    assert_equal masq_path, '/masq'

    @user.add_role :panitia
    @user.add_role :admin
    new_user = create(:user)

    post :masq, { username: new_user.username }
    assert_redirected_to home_path
    assert_equal session[:masq_username], new_user.username
    assert_equal flash[:notice], 'Masq!'
  end

  test 'masq without permissions' do
    assert_raises(ActionController::RoutingError) { post :masq }
  end

  test 'masq username not found' do
    @user.add_role :panitia
    @user.add_role :admin

    post :masq, { username: 'asdf' }
    assert_redirected_to admin_path
    assert_equal session[:masq_username], nil
    assert_equal flash[:alert], 'Ga ketemu usernya :('
  end

  test 'unmasq' do
    session[:masq_username] = create(:user).username

    delete :unmasq
    assert_redirected_to home_path
    assert_nil session[:masq_username]
    assert_equal flash[:notice], 'Unmasq!'
  end
end
