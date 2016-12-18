class LongSubmissionsController < ApplicationController
  load_and_authorize_resource

  def submit
    LongSubmission.transaction do
      @long_submission.submission_pages.destroy_all
      @long_submission.update!(submission_params)
    end
    redirect_to @contest, notice: 'Jawaban bagian B berhasil diupload!'
  rescue ActiveRecord::ActiveRecordError
    redirect_to @contest,
                alert: 'Jawaban bagian B gagal dikirim! Jika ini berlanjut, ' \
                "#{ActionController::Base.helpers.link_to 'kontak kami',
                                                          contact_path}."
  end

  def destroy_submissions
    if @long_submission.submission_pages.destroy_all
      flash[:notice] = 'Jawaban Anda berhasil dibuang!'
    else
      flash[:alert] = 'Jawaban Anda gagal dibuang! Jika ini terjadi terus, ' \
                      "#{ActionController::Base.helpers.link_to 'kontak kami',
                                                                contact_path}."
    end
    redirect_to @contest
  end

  def download
    @long_submission.compress
    send_file @long_submission.zip_location
  rescue Errno::ENOENT
    redirect_to @contest, alert: 'Jawaban Anda tidak ditemukan! ' \
    'Mohon buang dan upload ulang.'
  end

  def mark
    if !@long_problem.start_mark_final && !@long_problem.all_marked? &&
       current_user.has_role?(:marker, @long_problem)
      redirect_to mark_solo_path(@long_problem)
    end
    @long_submissions = @long_problem.long_submissions
                                     .submitted.order(:user_contest_id)
                                     .includes(:user_contest)
    @markers = User.with_role :marker, @long_problem
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

  def submission_params
    params.require(:long_submission).permit(
      submission_pages_attributes: [:page_number, :submission, :_destroy, :id]
    )
  end
end
