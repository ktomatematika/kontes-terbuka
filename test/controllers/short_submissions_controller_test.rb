require 'test_helper'

class ShortSubmissionsControllerTest < ActionController::TestCase
  setup :login_and_be_admin, :create_items

  test 'routes' do
    assert_equal contest_short_submissions_path(@c),
                 "/contests/#{@c.to_param}/short-submissions"
  end

  test 'create_on_contest' do
    test_abilities ShortSubmission, :create_on_contest, [], [nil]
    create_list(:short_problem, 5, contest: @c).each do |sp|
      create(:short_submission, short_problem: sp, user_contest: @uc)
    end
    ss_hash = Hash[@c.short_problems.map { |s| [s.id, s.id] }]
    post :create_on_contest, contest_id: @c.id, short_submission: ss_hash
    assert_redirected_to @c

    assert @uc.short_submissions.count >= 5
    @uc.short_submissions.each do |ss|
      assert_equal ss.short_problem_id, ss.answer.to_i
    end
  end

  private

  def create_items
    @uc = create(:user_contest, user: @user)
    @ss = create(:short_submission, user_contest: @uc)
    @c = @uc.contest
  end
end
