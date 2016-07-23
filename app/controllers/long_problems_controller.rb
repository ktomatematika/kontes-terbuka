class LongProblemsController < ApplicationController
  after_action do
    authorize! params[:action].to_sym, @long_problem || LongProblem
  end

  def create
    contest = Contest.find(params[:contest_id])

    unless contest.long_problems.find_by_problem_no(
      long_problem_params[:problem_no]
    )
      contest.long_problems.create(long_problem_params).fill_long_submissions
    end
    redirect_to contest_admin_path(id: contest.id)
  end

  def edit
    @contest = Contest.find(params[:contest_id])
    @long_problem = @contest.long_problems.find(params[:id])
  end

  def update
    @contest = Contest.find(params[:contest_id])
    @long_problem = @contest.long_problems.find(params[:id])
    if @long_problem.update(long_problem_params)
      redirect_to contest_admin_path(id: @contest.id)
    else
      render 'edit', alert: 'Esai gagal diupdate!'
    end
  end

  def destroy
    contest = Contest.find(params[:contest_id])
    @contest.long_problems.find(params[:id]).destroy
    Ajat.info "long_prob_destroyed|contest:#{params[:contest_id]}|" \
    "id:#{params[:id]}"
    redirect_to contest_admin_path(id: contest.id)
  end

  def submit
    # contest_id = submission_params['contest_id']
    # problem_id = submission_params['problem_id']
    # if submission_params.key?(:long_submissions_attributes)
    #   concern_params = submission_params[:long_submissions_attributes]
    #   concern_params.each_key do |s|
    #     next if concern_params[s][:submission].blank?
    #     long_submission_temp = LongSubmission.where(
    #       long_problem_id: problem_id, user_id: current_user.id
    #     )
    #     page_number = concern_params[s]['page']
    #     if long_submission_temp.where(page: page_number).blank?
    #       @long_problem = LongProblem.find(problem_id)
    #       @long_submission = @long_problem.long_submissions.create(
    #         user_id: current_user.id,
    #         submission: concern_params[s][:submission],
    #         page: page_number
    #       )
    #     else
    #       @long_submission =
    #         long_submission_temp.where(page: page_number).first
    #       @long_submission.update(submission: concern_params[s][:submission])
    #       @long_submission.save
    #     end
    #   end
    # end
    # redirect_to Contest.find(contest_id)
  end

  def mark
    @contest = @long_problem.contest
    @long_submissions = LongSubmission.where(long_problem: @long_problem)
                                      .reject do |ls|
      SubmissionPage.where(long_submission: ls).empty?
    end

    @markers = User.with_role(:marker, @long_problem).reject do |u|
      u == current_user
    end
  end

  def mark_solo
    @long_problem = LongProblem.find(params[:id])
    mark
  end

  def download
    @long_problem = LongProblem.find(params[:id])
    unless File.file? @long_problem.zip_location
      @long_problem.compress_submissions
    end

    send_file @long_problem.zip_location, type: 'application/zip',
                                          disposition: 'attachment'
  end

  def submit_temporary_markings
    params.each do |id, val|
      mark = val[:mark]
      tags = val[:tags]

      next if mark == '' && tags == ''
      TemporaryMarking.find_or_initialize_by(long_submission_id: id,
                                             user: current_user)
                      .update(tags: tags, mark: mark)
    end
    redirect_to mark_solo_path(params[:id]), notice: 'Nilai berhasil diupdate!'
  end

  def mark_final
    @long_problem = LongProblem.find(params[:id])
    mark
  end

  private

  def long_problem_params
    params.require(:long_problem).permit(:problem_no, :statement, :answer)
  end

  def submission_params
    params[:long_problem]
  end
end
