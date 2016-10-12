class LongProblemsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource only: :mark_solo

  def create
    contest = Contest.find(params[:contest_id])

    if contest.long_problems.find_by_problem_no(
      long_problem_params[:problem_no]
    ).nil?
      contest.long_problems.create(long_problem_params).fill_long_submissions
    end
    redirect_to contest_admin_path(id: contest.id)
  end

  def edit
    @contest = Contest.find(params[:contest_id])
  end

  def update
    @contest = Contest.find(params[:contest_id])
    if @long_problem.update(long_problem_params)
      redirect_to contest_admin_path(id: @contest.id)
    else
      render 'edit', alert: 'Esai gagal diupdate!'
    end
  end

  def destroy
    contest = Contest.find(params[:contest_id])
    long_problem = contest.long_problems.find(params[:id])
    authorize! :destroy, long_problem
    long_problem.destroy
    Ajat.info "long_prob_destroyed|contest:#{params[:contest_id]}|" \
    "id:#{params[:id]}"
    redirect_to contest_admin_path(id: contest.id)
  end

  def mark
    @contest = @long_problem.contest
    @long_submissions = @long_problem.long_submissions.submitted

    @markers = User.with_role(:marker, @long_problem)
  end

  def mark_solo
    if (!current_user.has_role?(:marker, @long_problem) ||
        @long_problem.start_mark_final) && can?(:mark_final, @long_problem)
      redirect_to mark_final_path(@long_problem)
    else
      authorize! :mark_solo, @long_problem
      mark
      @markers = @markers.where.not(id: current_user.id)
    end
  end

  def download
    loc = @long_problem.zip_location
    @long_problem.compress_submissions

    send_file loc
  end

  def submit_temporary_markings
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
    redirect_to mark_solo_path(params[:id]), notice: 'Nilai berhasil diupdate!'
  end

  def mark_final
    if !@long_problem.start_mark_final && !@long_problem.all_marked? &&
       current_user.has_role?(:marker, @long_problem)
      redirect_to mark_solo_path(@long_problem)
    end
    mark
    @long_submissions = @long_submissions.includes(:user_contest)
  end

  def submit_final_markings
    params[:marking].each do |id, val|
      feedback = (val[:comment] + ' ' + val[:suggestion]).strip
      score = LongSubmission::SCORE_HASH.key(val[:score])

      update_hash = { score: score, feedback: feedback }
      update_hash.delete(:score) if val[:score].empty?
      update_hash.delete(:feedback) if feedback.empty?

      LongSubmission.find(id).update(update_hash)
    end
    redirect_to mark_final_path(params[:id]), notice: 'Nilai berhasil diupdate!'
  end

  def autofill
    @long_problem.autofill
    redirect_to mark_final_path(params[:id]), notice: 'Sulap selesai!'
  end

  def start_mark_final
    @long_problem.update(start_mark_final: true)
    redirect_to mark_final_path(params[:id]), notice: 'Langsung diskusi!'
  end

  def upload_report
    if @long_problem.update(report_params)
      flash[:notice] = 'Laporan telah diupload!'
    else
      flash[:alert] = 'Laporan gagal diupload!'
    end
    redirect_to mark_final_path
  end

  private

  def long_problem_params
    params.require(:long_problem).permit(:problem_no, :statement, :answer)
  end

  def report_params
    params.require(:long_problem).permit(:report)
  end
end
