require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test 'routes' do
    assert_equal root_path,
                 '/'
    assert_equal sign_users_path,
                 '/users/sign'
  end

  test 'new' do
    get :new
    assert_redirected_to sign_users_path(anchor: 'login')
  end

  test 'new with redirect params' do
    get :new, redirect: '/contests'
    assert_redirected_to sign_users_path(redirect: '/contests', anchor: 'login')
  end

  test 'new logged in' do
    login_and_be_admin
    get :new
    assert_redirected_to root_path
  end

  test 'create with username' do
    u = create(:user, password: 'asdfasdf')
    u.enable
    post :create, username: u.username, password: 'asdfasdf'

    assert_redirected_to root_path
    assert_equal cookies[:auth_token], u.auth_token
  end

  test 'create with email' do
    u = create(:user, password: 'asdfasdf')
    u.enable
    post :create, username: u.email, password: 'asdfasdf'

    assert_redirected_to root_path
    assert_equal cookies[:auth_token], u.auth_token
  end

  test 'create with redirect' do
    u = create(:user, password: 'asdfasdf')
    u.enable
    post :create, username: u.username, redirect: '/users', password: 'asdfasdf'

    assert_redirected_to users_path
    assert_equal cookies[:auth_token], u.auth_token
  end

  test 'create with no user' do
    post :create, username: 'asalaja', password: 'asdfasdf'

    assert_template 'welcome/sign'
    assert_equal flash[:alert], 'Username atau email Anda salah.'
  end

  test 'create not enabled' do
    u = create(:user, password: 'asdfasdf')
    post :create, username: u.username, password: 'asdfasdf'

    assert_template 'welcome/sign'
    assert_equal flash[:alert], 'Anda perlu melakukan verifikasi terlebih ' \
      'dahulu. Cek email Anda untuk linknya.'
  end

  test 'create enabled yet verification not nil' do
    u = create(:user, password: 'asdfasdf', enabled: true, verification: 'asdf')
    post :create, username: u.username, password: 'asdfasdf'

    assert_template 'welcome/sign'
    assert_equal flash[:alert], 'Anda perlu mereset password Anda. Cek link ' \
      'di email Anda.'
  end

  test 'create wrong password' do
    u = create(:user, password: 'asdfasdf')
    u.enable
    post :create, username: u.username, password: 'asdfasdf2'

    assert_template 'welcome/sign'
    assert_equal flash[:alert], 'Password Anda salah. Ini percobaan ke-1 ' \
      'dari 10 Anda. Setelah itu, Anda perlu mereset password.'
  end

  test 'create wrong password after some tries' do
    u = create(:user, password: 'asdfasdf', tries: 3)
    u.enable
    post :create, username: u.username, password: 'asdfasdf2'

    assert_template 'welcome/sign'
    assert_equal flash[:alert], 'Password Anda salah. Ini percobaan ke-4 ' \
      'dari 10 Anda. Setelah itu, Anda perlu mereset password.'
  end

  test 'create wrong password after limit tries' do
    u = create(:user, password: 'asdfasdf', tries: 9)
    u.enable
    post :create, username: u.username, password: 'asdfasdf2'

    assert_template 'welcome/sign'
    assert_equal flash[:alert], 'Anda sudah terlalu banyak mencoba ' \
      'dan perlu mereset password. Silakan cek link di email Anda.'
  end

  test 'create wrong password after so many tries' do
    u = create(:user, password: 'asdfasdf', tries: 10)
    u.enable
    post :create, username: u.username, password: 'asdfasdf2'

    assert_template 'welcome/sign'
    assert_equal flash[:alert], 'Anda sudah terlalu banyak mencoba ' \
      'dan perlu mereset password. Silakan cek link di email Anda.'
  end

  test 'create right password after so many tries' do
    u = create(:user, password: 'asdfasdf', tries: 10)
    u.enable
    post :create, username: u.username, password: 'asdfasdf'

    assert_template 'welcome/sign'
    assert_equal flash[:alert], 'Anda sudah terlalu banyak mencoba ' \
      'dan perlu mereset password. Silakan cek link di email Anda.'
  end

  test 'create right password resets tries to 0' do
    u = create(:user, password: 'asdfasdf', tries: 5)
    u.enable
    post :create, username: u.username, password: 'asdfasdf'

    assert_redirected_to root_path
    assert_equal cookies[:auth_token], u.auth_token
    assert_equal u.reload.tries, 0
  end

  test 'destroy' do
    login_and_be_admin
    delete :destroy

    assert_equal cookies[:auth_token], nil
    assert_redirected_to root_path
    assert_equal flash[:notice], 'Anda berhasil keluar.'
    assert_equal session.to_h.except('flash'), {}
  end
end
