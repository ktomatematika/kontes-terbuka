require 'test_helper'

class FeedbackQuestionsControllerTest < ActionController::TestCase
  setup :login_and_create_contest
  setup do |action|
    be_admin unless %w(test_routes test_no_permissions).include? action.name
  end

  test 'routes' do
    assert_equal contest_feedback_questions_path(@c),
                 "/contests/#{@c.to_param}/feedback-questions"
    assert_equal edit_feedback_question_path(@fq),
                 "/feedback-questions/#{@fq.id}/edit"
    assert_equal feedback_question_path(@fq),
                 "/feedback-questions/#{@fq.id}"
    assert_equal copy_contest_feedback_questions_path(@c),
                 "/contests/#{@c.to_param}/feedback-questions/copy"
  end

  test 'no permissions' do
    assert_raise ActionController::RoutingError do
      post :create, contest_id: @c.id,
                    feedback_question: { question: 'Hello there' }
    end
  end

  test 'create' do
    post :create, contest_id: @c.id,
                  feedback_question: { question: 'Hello there' }
    assert_redirected_to admin_contest_path @c
    assert_equal @c.feedback_questions.where(question: 'Hello there').count, 1
  end

  test 'destroy' do
    delete :destroy, id: @fq.id
    assert_redirected_to admin_contest_path @c
    assert_nil Contest.find_by id: @fq.id
  end

  test 'edit' do
    get :edit, id: @fq.id
    assert_response 200
  end

  test 'patch update' do
    patch :update, id: @fq.id, feedback_question: { question: 'asdf' }
    @fq.reload
    assert_redirected_to admin_contest_path @c
    assert_equal @fq.question, 'asdf'
  end

  test 'put update' do
    put :update, id: @fq.id, feedback_question: { question: 'asdf' }
    @fq.reload
    assert_redirected_to admin_contest_path @c
    assert_equal @fq.question, 'asdf'
  end

  test 'copy across contests' do
    other_c = create(:contest)
    5.times { |i| create(:feedback_question, contest: other_c, question: i) }
    @c.feedback_questions.destroy_all

    post :copy_across_contests, contest_id: @c.id, other_contest_id: other_c.id
    assert_redirected_to admin_contest_path @c
    assert_equal flash[:notice], 'FQ berhasil dicopy!'

    @c.feedback_questions.each do |fq|
      assert_equal other_c.feedback_questions.where(
        question: fq.question
      ).count, 1
    end
  end

  test 'destroy_on_contest' do
    create_list(:feedback_question, 5, contest: @c)
    delete :destroy_on_contest, contest_id: @c.id

    assert_redirected_to admin_contest_path @c
    assert_equal @c.feedback_questions.count, 0
  end

  private

  def login_and_create_contest
    @user = create(:user)
    @request.cookies[:auth_token] = @user.auth_token
    @fq = create(:feedback_question)
    @c = @fq.contest
  end

  def be_admin
    @user.add_role :panitia
    @user.add_role :admin
  end
end
