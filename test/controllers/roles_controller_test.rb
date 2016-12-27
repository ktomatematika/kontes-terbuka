require 'test_helper'

class RolesControllerTest < ActionController::TestCase
  setup :login_and_be_admin, :create_items

  test 'routes' do
    assert_equal marker_long_problem_path(@lp),
                 "/long-problems/#{@lp.id}/marker"
    assert_equal marker_contest_path(@c),
                 "/contests/#{@c.to_param}/marker"
    assert_equal roles_path, '/roles'

    r = Role.create
    assert_equal role_path(r), "/roles/#{r.id}"
  end

  test 'assign_markers' do
    test_abilities Role, :assign_markers, [nil, :panitia, :marker],
                   [:marking_manager, :admin]
    get :assign_markers, id: @c.id
    assert_response 200
  end

  test 'create_marker' do
    test_abilities Role, :create_marker, [nil, :panitia, :marker],
                   [:marking_manager, :admin]
    marker = create(:user)
    post :create_marker, id: @lp.id, username: marker.username
    assert_equal flash[:notice], 'Korektor berhasil ditambahkan!'
    assert_redirected_to marker_contest_path(@c)
    assert marker.has_role? :marker, @lp
  end

  test 'create_marker with no username' do
    test_abilities Role, :create_marker, [nil, :panitia, :marker],
                   [:marking_manager, :admin]
    marker = create(:user)
    post :create_marker, id: @lp.id, username: (marker.username + 'a')
    assert_equal flash[:alert], 'User tidak ditemukan!'
    assert_redirected_to marker_contest_path(@c)
  end

  test 'remove_marker' do
    test_abilities Role, :remove_marker, [nil, :panitia, :marker],
                   [:marking_manager, :admin]
    marker = create(:user)
    marker.add_role :marker, @lp
    delete :remove_marker, id: @lp.id, user_id: marker.id
    assert_equal flash[:notice], 'Korektor berhasil dibuang!'
    assert_redirected_to marker_contest_path(@c)
    assert_not marker.has_role? :marker, @lp
  end

  test 'manage' do
    test_abilities Role, :manage, [nil, :panitia], [:admin]

    get :manage
    assert_response 200
  end

  test 'create' do
    test_abilities Role, :create, [nil, :panitia], [:admin]

    post :create, username: @user.username, role_name: :panitia
    assert_redirected_to roles_path
    assert_equal flash[:notice], 'Role berhasil ditambahkan!'

    assert @user.has_role? :panitia
  end

  test 'create without username' do
    post :create, username: 'asdf', role_name: :panitia
    assert_redirected_to roles_path
    assert_equal flash[:alert], 'Role gagal ditambahkan!'
  end

  test 'destroy' do
    test_abilities Role, :destroy, [nil, :panitia], [:admin]

    delete :destroy, user_id: @user.id, id: @user.roles.find_by(name: 'admin')
    assert_redirected_to roles_path
    assert_equal flash[:notice], 'Role berhasil dibuang!'

    assert_not @user.has_role? :admin
  end

  private

  def create_items
    @lp = create(:long_problem)
    @c = @lp.contest
  end
end
