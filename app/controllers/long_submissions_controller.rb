class LongSubmissionsController < ApplicationController
  load_resource :long_problem
  load_and_authorize_resource :long_submission

  def create
    contest = @long_problem.contest
    @long_submission.long_problem = @long_problem
    @long_submission.user_contest_id = params[:user_contest_id]
    @long_submission.submission_pages.each do |sp|
      sp.long_submission = @long_submission
    end

    if @long_submission.save
      redirect_to contest, notice: 'Jawaban bagian B berhasil diupload!'
    else
      redirect_to contest,
                  alert: 'Jawaban bagian B gagal dikirim! ' \
                  'Jika ini berlanjut, ' \
                  "#{ActionController::Base.helpers.link_to 'kontak kami',
                                                            contact_path}."
    end
  end

  def destroy
    if @long_submission.destroy
      flash[:notice] = 'Jawaban Anda berhasil dibuang!'
    else
      flash[:alert] = 'Jawaban Anda gagal dibuang! Jika ini terjadi terus, ' \
                      "#{ActionController::Base.helpers.link_to 'kontak kami',
                                                                contact_path}."
    end
    redirect_to contest_path(@long_submission.long_problem.contest)
  end

  def download
    @long_submission.compress
    send_file @long_submission.zip_location
  rescue Errno::ENOENT
    redirect_to contest_path(@long_submission.long_problem.contest),
                alert: 'Jawaban Anda tidak ditemukan! Mohon buang ' \
                'dan upload ulang.'
  end

  def mark
    if !@long_problem.start_mark_final && !@long_problem.all_marked? &&
       current_user.has_role?(:marker, @long_problem)
      redirect_to mark_solo_path(@long_problem)
    end
    @long_submissions = @long_problem.long_submissions
                                     .order(:user_contest_id)
                                     .includes(:user_contest)
    @markers = User.with_role :marker, @long_problem
    @contest = @long_problem.contest
  end

  def submit_mark
    params[:marking].each do |id, val|
      feedback = (val[:comment] + ' ' + val[:suggestion]).strip
      score = LongSubmission::SCORE_HASH.key(val[:score])

      update_hash = { score: score, feedback: feedback }
      update_hash.delete(:score) if val[:score].empty?
      update_hash.delete(:feedback) if feedback.empty?

      LongSubmission.find(id).update(update_hash)
    end
    redirect_to long_problem_long_submissions_path(@long_problem),
                notice: 'Nilai berhasil diupdate!'
  end

  private

  def long_submission_params
    params.require(:long_submission).permit(
      submission_pages_attributes: [:page_number, :submission, :_destroy, :id]
    )
  end
end
