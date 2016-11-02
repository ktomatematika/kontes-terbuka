require 'test_helper'

class FeedbackAnswersControllerTest < ActionController::TestCase
  setup :login, :create_items
  setup do |action|
    unless %w(test_routes test_no_permissions).include? action.name
      promote(:admin)
    end
  end

  test 'routes' do
    assert_equal new_contest_feedback_answers_path(@c),
                 "/contests/#{@c.to_param}/feedback-answers/new"
    assert_equal contest_feedback_answers_path(@c),
                 "/contests/#{@c.to_param}/feedback-answers"
  end

  test 'no permissions' do
    assert_raise ActionController::RoutingError do
      get :download_on_contest, contest_id: @c.id
    end
  end

  test 'new_on_contest' do
    get :new_on_contest, contest_id: @c.id
    assert_response 200
  end

  test 'create_on_contest' do
    create_list(:feedback_question, 5, contest: @c)
    fa_hash = Hash[@c.feedback_questions.map { |f| [f.id, f.id] }]
    post :create_on_contest, contest_id: @c.id, feedback_answer: fa_hash
    assert_redirected_to contest_path(@c)
    assert_equal flash[:notice], 'Feedback berhasil dikirimkan!'

    assert @uc.feedback_answers.count >= 5
    @uc.feedback_answers.each do |fa|
      assert_equal fa.feedback_question_id, fa.answer.to_i
    end
  end

  test 'download_on_contest' do
    get :download_on_contest, contest_id: @c.id, format: :csv
    assert @response.header['Content-Disposition'].include?(
      "filename=\"Feedback #{@c}\".csv"
    )
    assert_response 200
    assert_equal @response.content_type, 'text/csv'
  end

  private

  def create_items
    @uc = create(:user_contest, user: @user)
    @fa = create(:feedback_answer, user_contest: @uc)
    @c = @uc.contest
  end
end
