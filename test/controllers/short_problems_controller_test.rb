require 'test_helper'

class ShortProblemsControllerTest < ActionController::TestCase
  setup :login_and_be_admin, :create_items

  test 'routes' do
    assert_equal contest_short_problems_path(@c),
                 "/contests/#{@c.to_param}/short-problems"
    assert_equal edit_short_problem_path(@sp),
                 "/short-problems/#{@sp.id}/edit"
    assert_equal short_problem_path(@sp),
                 "/short-problems/#{@sp.id}"
    assert_equal destroy_on_contest_contest_short_problems_path(@c),
                 "/contests/#{@c.to_param}/short-problems/destroy-on-contest"
  end

  test 'create' do
    test_abilities @sp, :create, [nil, :panitia], [:problem_admin, :admin]
    post :create, contest_id: @c.id,
                  short_problem: { statement: 'Hello there',
                                   problem_no: 5,
                                   answer: 3 }
    assert_redirected_to admin_contest_path @c
    assert_equal @c.short_problems.where(statement: 'Hello there').count, 1
    assert_equal flash[:notice], 'Short Problem terbuat!'
  end

  test 'edit' do
    test_abilities @sp, :edit, [nil, :panitia], [:problem_admin, :admin]
    get :edit, id: @sp.id
    assert_response 200
  end

  test 'patch update' do
    test_abilities @sp, :update, [nil, :panitia], [:problem_admin, :admin]
    patch :update, id: @sp.id, short_problem: { statement: 'asdf' }
    assert_redirected_to admin_contest_path @c
    assert_equal @sp.reload.statement, 'asdf'
    assert_equal flash[:notice], 'Short Problem terubah!'
  end

  test 'put update' do
    put :update, id: @sp.id, short_problem: { statement: 'asdf' }
    assert_redirected_to admin_contest_path @c
    assert_equal @sp.reload.statement, 'asdf'
    assert_equal flash[:notice], 'Short Problem terubah!'
  end

  test 'update fail' do
    patch :update, id: @sp.id, short_problem: { statement: '' }
    assert_template :edit
  end

  test 'destroy' do
    test_abilities @sp, :destroy, [nil, :panitia], [:problem_admin, :admin]
    delete :destroy, id: @sp.id
    assert_redirected_to admin_contest_path @c
    assert_nil ShortProblem.find_by id: @sp.id
    assert_equal flash[:notice], 'Short Problem hancur!'
  end

  test 'destroy_on_contest' do
    create_list(:short_problem, 5, contest: @c)
    test_abilities @sp, :destroy_on_contest, [nil, :panitia],
                   [:problem_admin, :admin]
    delete :destroy_on_contest, contest_id: @c.id
    assert_redirected_to admin_contest_path @c
    assert_equal flash[:notice], 'Bagian A hancur!'
    assert_equal @c.long_problems.count, 0
  end

  private

  def create_items
    @sp = create(:short_problem)
    @c = @sp.contest
  end
end
