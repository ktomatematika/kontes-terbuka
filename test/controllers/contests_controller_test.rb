require 'test_helper'

class ContestsControllerTest < ActionController::TestCase
  setup :login_and_be_admin, :create_items

  test 'routes' do
    assert_equal admin_contest_path(@c),
                 "/contests/#{@c.to_param}/admin"
    assert_equal summary_contest_path(@c),
                 "/contests/#{@c.to_param}/summary"
    assert_equal read_problems_contest_path(@c),
                 "/contests/#{@c.to_param}/read-problems"
    assert_equal results_contest_path(@c),
                 "/contests/#{@c.to_param}/results"
    assert_equal problem_pdf_contest_path(@c),
                 "/contests/#{@c.to_param}/problem-pdf"
    assert_equal ms_contest_path(@c),
                 "/contests/#{@c.to_param}/ms"
    assert_equal contests_path,
                 '/contests'
    assert_equal new_contest_path,
                 '/contests/new'
    assert_equal edit_contest_path(@c),
                 "/contests/#{@c.to_param}/edit"
    assert_equal contest_path(@c),
                 "/contests/#{@c.to_param}"
  end

  test 'admin' do
    test_abilities @c, :admin, [nil, :marker], [:panitia, :admin]
    get :admin, id: @c.id
    assert_response 200
  end

  test 'new' do
    test_abilities Contest, :new, [nil, :marker, :panitia, :problem_admin],
                   [:admin]
    get :new
    assert_response 200
  end

  test 'create' do
    test_abilities Contest, :create, [nil, :marker, :panitia, :problem_admin],
                   [:admin]
    contest_hash = attributes_for(:contest, name: 'Halo')
    post :create, contest: contest_hash

    c = Contest.find_by(name: 'Halo')
    assert_not_nil c
    assert_redirected_to contest_path(c)
  end

  test 'create fail' do
    contest_hash = attributes_for(:contest)
    contest_hash.delete(:start_time)
    assert_difference('Contest.count', 0) do
      post :create, contest: contest_hash
    end
    assert_template :new
  end

  test 'show not in contest' do
    test_abilities @c, :show, [], [nil]
    @c.update(start_time: Time.zone.now + 4.seconds,
              end_time: Time.zone.now + 5.seconds)
    get :show, id: @c.id
    assert_response 200
  end

  test 'show in contest without user contest' do
    @c.update(start_time: Time.zone.now - 4.seconds,
              end_time: Time.zone.now + 5.seconds)
    get :show, id: @c.id
    assert_redirected_to new_contest_user_contest_path(@c)
  end

  private

  def create_items
    @c = create(:contest)
  end
end
