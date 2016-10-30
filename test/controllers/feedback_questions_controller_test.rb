require 'test_helper'

class FeedbackQuestionsControllerTest < ActionController::TestCase
  def setup
    @user = create(:user)
    @request.cookies[:auth_token] = @user.auth_token
    @fq = create(:feedback_question)
    @c = @fq.contest
  end

  test 'routes' do
    assert_equal contest_feedback_questions_path(@c),
                 "/contests/#{@c.to_param}/feedback-questions"
    assert_equal new_contest_feedback_question_path(@c),
                 "/contests/#{@c.to_param}/feedback-questions/new"
    assert_equal edit_contest_feedback_question_path(@c, @fq),
                 "/contests/#{@c.to_param}/feedback-questions/#{@fq.id}/edit"
    assert_equal contest_feedback_question_path(@c, @fq),
                 "/contests/#{@c.to_param}/feedback-questions/#{@fq.id}"
  end

  test 'create' do
    @user.add_role :panitia
    @user.add_role :admin

    post :create, contest_id: @c.id,
                  feedback_question: { question: 'Hello there' }
    assert_redirected_to admin_contest_path @c
    assert_equal @c.feedback_questions.where(question: 'Hello there').count, 1
  end

  test 'destroy' do
    @user.add_role :panitia
    @user.add_role :admin

    delete :destroy, contest_id: @c.id, id: @fq.id
    assert_redirected_to admin_contest_path @c
    assert @fq.destroyed?
  end

  test 'edit' do
    @user.add_role :panitia
    @user.add_role :admin

    get :edit, contest_id: @c.id, id: @fq.id
    assert_response 200
  end

  test 'patch update' do
    @user.add_role :panitia
    @user.add_role :admin

    patch :update, contest_id: @c.id, id: @fq.id,
                   feedback_question: { question: 'asdf' }
    assert_redirected_to admin_contest_path @c
    assert_equal @fq.question, 'asdf'
  end

  test 'put update' do
    @user.add_role :panitia
    @user.add_role :admin

    put :update, contest_id: @c.id, id: @fq.id,
                 feedback_question: { question: 'asdf' }
    assert_redirected_to admin_contest_path @c
    assert_equal @fq.question, 'asdf'
  end

  test 'copy across contests' do
    @user.add_role :panitia
    @user.add_role :admin

    other_c = create(:contest)
    create_list(:feedback_question, 5, contest: @c)

    post :copy_across_contests, id: other_c.id, other_contest_id: @c.id
    assert_redirected_to admin_contest_path
    assert_equal @flash[:notice], 'FQ berhasil dicopy!'

    other_c.feedback_questions.each do |fq|
      assert_equal @c.feedback_questions.where(question: fq.question).count, 1
    end
  end
end
