require 'test_helper'

class FeedbackAnswersControllerTest < ActionController::TestCase
  def setup
    @user = create(:user)
    @request.cookies[:auth_token] = @user.auth_token
    @fq = create(:feedback_question)
    @c = @fq.contest
  end

  test 'routes' do
    assert_equal contest_feedback_questions_path(contest_id: @c.id),
                 '/contests/3/feedback-questions'
    assert_equal new_contest_feedback_question_path(contest_id: @c.id),
                 '/contests/3/feedback-questions/new'
    assert_equal edit_contest_feedback_question_path(contest_id: @c.id),
                 '/contests/3/feedback-questions/10/edit'
    assert_equal contest_feedback_question_path(contest_id: @c.id, id: @fq.id),
                 '/contests/3/feedback-questions/10'
  end

  test 'create' do
    post :create, params: { contest_id: @c.id, feedback_question: { question: 'Hello there' } }
    assert_redirected_to admin_contest_path id: @c.id
    assert_equal c.feedback_questions.where(question: 'Hello there').count, 1
  end

  test 'destroy' do
    delete :destroy, params: { contest_id: @c.id, id: @fq.id }
    assert_redirected_to admin_contest_path id: @c.id
    assert @fq.destroyed?
  end

  test 'edit' do
    get :edit, params: { contest_id: @c.id, id: @fq.id }
    assert_response 200
  end

  test 'patch update' do
    patch :update, params: { contest_id: @c.id, id: @fq.id, feedback_question: { question: 'asdf' } }
    assert_redirected_to admin_contest_path id: @c.id
    assert_equal @fq.question, 'asdf'
  end

  test 'put update' do
    put :update, params: { contest_id: @c.id, id: @fq.id, feedback_question: { question: 'asdf' } }
    assert_redirected_to admin_contest_path id: @c.id
    assert_equal @fq.question, 'asdf'
  end

  test 'copy' do
    other_c = create(:contest)
    create_list(:feedback_question, 5, contest: @c)

    post :copy, params: { id: other_c.id, other_contest_id: @c.id }
    assert_redirected_to admin_contest_path
    assert_equal @flash[:notice], 'FQ berhasil dicopy!'

    other_c.feedback_questions.each do |fq|
      assert_equal @c.feedback_questions.where(question: fq.question).count, 1
    end
  end
end
