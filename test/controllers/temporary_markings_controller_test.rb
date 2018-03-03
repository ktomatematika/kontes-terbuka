# frozen_string_literal: true

require 'test_helper'

class TemporaryMarkingsControllerTest < ActionController::TestCase
  setup :login_and_be_admin, :create_items

  test 'routes' do
    assert_equal long_problem_temporary_markings_path(
      long_problem_id: @lp.id
    ), "/long-problems/#{@lp.id}/temporary-markings"
  end

  test 'new_on_long_problem' do
    test_abilities @lp, :mark,
                   [nil, :panitia, [:marker, create(:long_problem)]],
                   [[:marker, @lp], :admin]
    @user.add_role :marker, @lp
    get :new_on_long_problem, long_problem_id: @lp.id
    assert_response 200
  end

  test 'modify_on_long_problem' do
    lss = create_list(:long_submission, 4, long_problem: @lp)
    TemporaryMarking.create(long_submission: lss.second, user: @user,
                            mark: 7, tags: 'halo')
    TemporaryMarking.create(long_submission: lss.third, user: @user,
                            mark: 7, tags: 'halo')

    update_hash = {
      lss.first.id => { mark: 3, tags: 'asdf' },
      lss.second.id => { mark: '-', tags: '' },
      lss.third.id => { mark: '', tags: 'wer' },
      lss.fourth.id => { mark: '', tags: '' }
    }
    post :modify_on_long_problem, long_problem_id: @lp.id,
                                  marking: update_hash

    assert_redirected_to long_problem_temporary_markings_path(
      long_problem_id: @lp.id
    )
    assert_equal flash[:notice], 'Nilai berhasil diupdate!'

    tm1 = TemporaryMarking.find_by(long_submission: lss.first, user: @user)
    tm2 = TemporaryMarking.find_by(long_submission: lss.second, user: @user)
    tm3 = TemporaryMarking.find_by(long_submission: lss.third, user: @user)
    tm4 = TemporaryMarking.find_by(long_submission: lss.fourth, user: @user)
    assert_equal tm1.mark, 3
    assert_equal tm1.tags, 'asdf'
    assert_nil tm2.mark
    assert_equal tm2.tags, 'halo'
    assert_equal tm3.mark, 7
    assert_equal tm3.tags, 'wer'
    assert_nil tm4.mark
    assert_nil tm4.tags
  end

  private

  def create_items
    @lp = create(:long_problem)
    @c = @lp.contest
  end
end
