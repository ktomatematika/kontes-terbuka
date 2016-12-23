class TemporaryMarkingsController < ApplicationController
  load_and_authorize_resource :long_problem

  def new_on_long_problem
    if !current_user.has_role?(:marker, @long_problem) ||
       @long_problem.start_mark_final
      redirect_to long_problem_long_submissions_path(
        long_problem_id: @long_problem.id
      )
    else
      @contest = @long_problem.contest
      @long_submissions = @long_problem.long_submissions.order(:user_contest_id)
      @markers = User.with_role(:marker, @long_problem)
                     .where.not(id: current_user.id)
    end
  end

  def modify_on_long_problem
    params[:marking].each do |id, val|
      mark = val[:mark]
      tags = val[:tags]

      update_hash = { mark: LongSubmission::SCORE_HASH.key(mark), tags: tags }
      update_hash.delete(:mark) if mark.empty?
      update_hash.delete(:tags) if tags.empty?

      TemporaryMarking.find_or_initialize_by(long_submission_id: id,
                                             user: current_user)
                      .update(update_hash)
    end
    redirect_to long_problem_temporary_markings_path(
      long_problem_id: @long_problem.id
    ), notice: 'Nilai berhasil diupdate!'
  end
end
