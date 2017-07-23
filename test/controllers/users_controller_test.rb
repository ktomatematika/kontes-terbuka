# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test 'routes' do
    login_and_be_admin

    assert_equal mini_update_user_path(@user),
                 "/users/#{@user.to_param}/mini-update"
    assert_equal change_password_user_path(@user),
                 "/users/#{@user.to_param}/change-password"
    assert_equal register_users_path,
                 '/users/register'
    assert_equal forgot_users_path,
                 '/users/forgot'
    assert_equal check_users_path,
                 '/users/check'
    assert_equal verify_users_path(verification: @user.verification),
                 "/users/verify/#{@user.verification}"
    assert_equal reset_password_users_path(verification: @user.verification),
                 "/users/reset-password/#{@user.verification}"
    assert_equal users_path,
                 '/users'
    assert_equal new_user_path,
                 '/users/new'
    assert_equal edit_user_path(@user),
                 "/users/#{@user.to_param}/edit"
    assert_equal user_path(@user),
                 "/users/#{@user.to_param}"
  end

  test 'new' do
    get :new
    assert_redirected_to sign_users_path(anchor: 'register')
  end

  test 'new on login' do
    login_and_be_admin
    get :new
    assert_redirected_to root_path
  end

  test 'create' do
    post :create, user: build(:user).attributes.merge(password: 'asdfasdf')
    assert_redirected_to root_path
    assert_equal flash[:notice], 'Registrasi berhasil! ' \
      'Sekarang, lakukan verifikasi dengan membuka link yang telah ' \
      'kami berikan di email Anda.'
  end

  test 'create fail' do
    post :create, user: build(:user,
                              province_id: nil).attributes
      .merge(password: 'asdfasdf')

    assert_template 'welcome/sign'
    assert_equal flash[:alert], 'Terdapat kesalahan dalam ' \
    ' registrasi. Jika registrasi masih tidak bisa dilakukan, ' \
      "#{ActionController::Base.helpers.link_to 'kontak kami',
                                                contact_path}."
  end

  test 'show' do
    login_and_be_admin
    @user.enable

    user = create(:user)
    user.enable
    disabled = create(:user)
    panitia = create(:user)
    panitia.add_role :panitia
    assert Ability.new(user).can?(:show, user)
    assert Ability.new(user).can?(:show, @user)
    assert Ability.new(user).cannot?(:show, disabled)
    assert Ability.new(panitia).can?(:show, @user)
    assert Ability.new(panitia).can?(:show, disabled)
    assert Ability.new(user).can?(:show_full, user)
    assert Ability.new(user).cannot?(:show_full, @user)
    assert Ability.new(panitia).can?(:show_full, @user)

    get :show, id: @user.id
    assert_response 200
  end

  test 'index' do
    test_abilities User, :index, [], [nil]
    test_abilities User, :index_full, [nil], %i[panitia admin]

    login_and_be_admin
    get :index
    assert_response 200
  end

  test 'edit' do
    test_abilities User, :edit, [nil, :panitia], %i[user_admin admin]

    login_and_be_admin
    get :edit, id: @user.id
    assert_response 200
  end

  test 'update' do
    test_abilities User, :update, [nil, :panitia], %i[user_admin admin]

    login_and_be_admin
    put :update, id: @user.id, user: { fullname: 'Coba halo' }
    assert_redirected_to user_path(@user)
    assert_equal flash[:notice], 'User berhasil diupdate!'
    assert_equal @user.reload.fullname, 'Coba halo'
  end

  test 'update fail' do
    test_abilities User, :update, [nil, :panitia], %i[user_admin admin]

    login_and_be_admin
    get :update, id: @user.id, user: { color_id: nil }
    assert_template :edit
    assert_equal flash[:alert], 'Terdapat kesalahan!'
  end

  test 'mini_update' do
    login_and_be_admin

    u = create(:user)
    p = create(:user)
    p.add_role :panitia
    a = create(:user)
    a.add_role :panitia
    a.add_role :user_admin
    assert Ability.new(u).can?(:mini_edit, u)
    assert Ability.new(u).cannot?(:mini_edit, @user)
    assert Ability.new(p).cannot?(:mini_edit, @user)
    assert Ability.new(a).can?(:mini_edit, @user)
    assert Ability.new(u).can?(:mini_update, u)
    assert Ability.new(u).cannot?(:mini_update, @user)
    assert Ability.new(p).cannot?(:mini_update, @user)
    assert Ability.new(a).can?(:mini_update, @user)

    put :mini_update, id: @user.id, user: { timezone: 'WITA' }
    assert_redirected_to user_path(@user)
    assert_equal flash[:notice], 'User berhasil diupdate!'
    assert_equal @user.reload.timezone, 'WITA'
  end

  test 'mini_update fail' do
    login_and_be_admin

    put :mini_update, id: @user.id, user: { timezone: 'BODOH' }
    assert_redirected_to user_path(@user)
    assert_equal flash[:alert], 'Terdapat kesalahan dalam mengupdate User!'
  end

  test 'destroy' do
    test_abilities User, :destroy, [nil, :panitia], %i[user_admin admin]

    login_and_be_admin
    delete :destroy, id: @user.id
    assert_equal User.where(id: @user.id).count, 0
  end

  test 'check_unique not unique username' do
    u = create(:user)
    post :check_unique, username: u.username
    assert_equal @response.body, 'false'
  end

  test 'check_unique not unique username different case' do
    create(:user, username: 'asdfgh')
    post :check_unique, username: 'ASdfGH'
    assert_equal @response.body, 'false'
  end

  test 'check_unique not unique email' do
    u = create(:user)
    post :check_unique, email: u.email
    assert_equal @response.body, 'false'
  end

  test 'check_unique is unique' do
    post :check_unique, email: 'coba@gmail.coba'
    assert_equal @response.body, 'true'
  end

  test 'referrer_update' do
    test_abilities User, :referrer_update, [], [nil]
    login_and_be_admin
    r = create(:referrer)
    patch :referrer_update, id: @user.id, user: { referrer_id: r.id }
    assert_redirected_to root_url
    assert_equal flash[:notice], 'Terima kasih sudah mengisi!'

    assert_equal @user.reload.referrer, r
  end

  test 'verify' do
    u = create(:user)
    get :verify, verification: u.verification

    assert_redirected_to login_users_path
    assert_equal flash[:notice], 'Verifikasi berhasil! Silakan login.'
    assert u.reload.enabled
  end

  test 'verify enabled' do
    u = create(:user, enabled: true)
    get :verify, verification: u.verification

    assert_redirected_to login_users_path
    assert_equal flash[:notice], 'Anda sudah terverifikasi!'
  end

  test 'verify nil user' do
    get :verify, verification: 'asdf'

    assert_redirected_to root_path
    assert_equal flash[:alert], 'Terjadi kegagalan dalam verifikasi ' \
      'atau reset password. Ini kemungkinan berarti Anda sudah ' \
      'terverifikasi atau password Anda sudah terreset, ataupun batas ' \
      'waktu verifikasi sudah lewat. Coba login; coba juga cek ulang link ' \
      'yang diberikan dalam email Anda. Jika masih tidak bisa juga, coba ' \
      'buat ulang user Anda, atau ' \
      "#{ActionController::Base.helpers.link_to 'kontak kami', contact_path}."
  end

  test 'reset_password' do
    get :reset_password, verification: 'asdf'
    assert_response 200
  end

  test 'process_reset_password' do
    u = create(:user)
    post :process_reset_password, verification: u.verification,
                                  new_password: 'asdfcoba',
                                  confirm_new_password: 'asdfcoba'

    assert_redirected_to login_users_path
    assert_equal flash[:notice], 'Password berhasil diubah! Silakan login.'

    u.reload
    assert_nil u.verification
    assert u.authenticate('asdfcoba')
  end

  test 'process_reset_password with no user' do
    post :process_reset_password, verification: 'asdf',
                                  new_password: 'asdfcoba',
                                  confirm_new_password: 'asdfcoba'

    assert_template :reset_password
    assert_equal flash[:alert], 'Terdapat kesalahan! Coba lagi.'
  end

  test 'process_reset_password with not matching password' do
    u = create(:user)
    post :process_reset_password, verification: u.verification,
                                  new_password: 'asdfcoba',
                                  confirm_new_password: 'asdfcoba2'

    assert_template :reset_password
    assert_equal flash[:alert], 'Password baru tidak cocok! Coba lagi.'
  end

  test 'change_password' do
    login_and_be_admin
    u = create(:user)
    assert Ability.new(u).can?(:change_password, u)
    assert Ability.new(u).cannot?(:change_password, @user)

    get :change_password, id: @user.id
    assert_response 200
  end

  test 'process_change_password' do
    login_and_be_admin
    u = create(:user)
    assert Ability.new(u).can?(:process_change_password, u)
    assert Ability.new(u).cannot?(:process_change_password, @user)

    @user.update(password: 'asdfasdf')
    post :process_change_password, id: @user.id, old_password: 'asdfasdf',
                                   new_password: 'asdfasdf2',
                                   confirm_new_password: 'asdfasdf2'
    assert_redirected_to user_path(@user)
    assert_equal flash[:notice], 'Password Anda berhasil diubah!'
    assert @user.reload.authenticate('asdfasdf2')
  end

  test 'process_change_password with different password' do
    login_and_be_admin
    @user.update(password: 'asdfasdf')
    post :process_change_password, id: @user.id, old_password: 'asdfasdf',
                                   new_password: 'asdfasdf2',
                                   confirm_new_password: 'asdfasdf3'
    assert_template :change_password
    assert_equal flash[:alert], 'Password baru Anda tidak cocok!'
  end

  test 'process_change_password with wrong old password' do
    login_and_be_admin
    @user.update(password: 'asdfasdf')
    post :process_change_password, id: @user.id, old_password: 'asdfasdf3',
                                   new_password: 'asdfasdf2',
                                   confirm_new_password: 'asdfasdf2'
    assert_template :change_password
    assert_equal flash[:alert], 'Password lama Anda salah!'
  end

  test 'process_forgot_password' do
    login_and_be_admin
    @user.enable
    post :process_forgot_password, username: @user.username, email: @user.email

    assert_template 'welcome/sign'
    assert_equal flash[:notice], 'Cek email Anda untuk instruksi selanjutnya.'
  end

  test 'process_forgot_password with no user' do
    login_and_be_admin
    post :process_forgot_password, username: 'asalaja', email: @user.email

    assert_template 'welcome/sign'
    assert_equal flash[:alert], 'Kombinasi user dan email tidak ditemukan.'
  end

  test 'process_forgot_password with not enabled user' do
    login_and_be_admin
    @user.update(enabled: false)
    post :process_forgot_password, username: @user.username, email: @user.email

    assert_template 'welcome/sign'
    assert_equal flash[:alert], 'Kamu belum verifikasi! ' \
    'Cek email Anda untuk verifikasi.'
  end
end
