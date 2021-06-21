# frozen_string_literal: true

require 'test_helper'

class LongSubmissionsControllerTest < ActionController::TestCase
  setup :login_and_be_admin, :create_items

  test 'routes' do
    ls = create(:long_submission)
    assert_equal long_submission_path(ls),
                 "/long-submissions/#{ls.id}"
    assert_equal long_problem_long_submissions_path(@lp),
                 "/long-problems/#{@lp.id}/long-submissions"
  end

  # TODO. Dev too lazy
  # test 'create' do
  # end

  test 'destroy' do
    test_abilities @ls, :destroy, [nil], [:admin]
    assert Ability.new(@ls.user_contest.user).can?(:destroy, @ls)

    delete :destroy, id: @ls.id
    assert_redirected_to root_path
    assert_nil LongSubmission.find_by(id: @ls.id)
  end

  test 'download' do
    test_abilities @ls, :download, [nil], [:admin]
    assert Ability.new(@ls.user_contest.user).can?(:download, @ls)

    get :download, id: @ls.id
    assert_equal IO.binread(@ls.zip_location), response.body
  end

  test 'download without file' do
    FileUtils.rm_r @ls.__send__(:location)

    get :download, id: @ls.id
    assert_redirected_to root_path
    assert_equal flash[:alert], 'Jawaban Anda tidak ditemukan! Mohon buang ' \
      'dan upload ulang.'
  end

  test 'mark' do
    test_abilities @ls, :mark, [nil], [[:marker, @lp], :admin]
    get :mark, long_problem_id: @lp.id
    assert_response 200
  end

  # TODO. Dev too lazy
  # test 'submit_mark' do
  # end

  test 'new' do
    test_abilities @ls, :new, [nil, :panitia, :problem_admin, :user_admin],
                   [:admin]
    get :new
    assert_response 200
  end

  private def create_items
    @ls = create(:long_submission)
    @lp = @ls.long_problem
    @c = @lp.contest
  end
end
