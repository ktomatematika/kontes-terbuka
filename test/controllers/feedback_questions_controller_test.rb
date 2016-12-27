require 'test_helper'

class FeedbackQuestionsControllerTest < ActionController::TestCase
  setup :login_and_be_admin, :create_items

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

  test 'create' do
    test_abilities @fq, :create, [nil, :panitia], [:admin]
    post :create, contest_id: @c.id,
                  feedback_question: { question: 'Hello there' }
    assert_redirected_to admin_contest_path @c
    assert_equal @c.feedback_questions.where(question: 'Hello there').count, 1
  end

  test 'destroy' do
    test_abilities @fq, :destroy, [nil, :panitia], [:admin]
    delete :destroy, id: @fq.id
    assert_redirected_to admin_contest_path @c
    assert_nil FeedbackQuestion.find_by id: @fq.id
  end

  test 'edit' do
    test_abilities @fq, :edit, [nil, :panitia], [:admin]
    get :edit, id: @fq.id
    assert_response 200
  end

  test 'patch update' do
    test_abilities @fq, :update, [nil, :panitia], [:admin]
    patch :update, id: @fq.id, feedback_question: { question: 'asdf' }
    assert_redirected_to admin_contest_path @c
    assert_equal @fq.reload.question, 'asdf'
  end

  test 'put update' do
    put :update, id: @fq.id, feedback_question: { question: 'asdf' }
    assert_redirected_to admin_contest_path @c
    assert_equal @fq.reload.question, 'asdf'
  end

  test 'copy across contests' do
    other_c = create(:contest)
    5.times { |i| create(:feedback_question, contest: other_c, question: i) }
    @c.feedback_questions.destroy_all

    test_abilities @fq, :update, [nil, :panitia], [:admin]
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

    test_abilities @fq, :destroy_on_contest, [nil, :panitia], [:admin]
    delete :destroy_on_contest, contest_id: @c.id

    assert_redirected_to admin_contest_path @c
    assert_equal @c.feedback_questions.count, 0
  end

  private

  def create_items
    @fq = create(:feedback_question)
    @c = @fq.contest
  end
end
