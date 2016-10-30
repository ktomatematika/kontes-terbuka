class LongSubmissionsController < ApplicationController
  def submit
    long_submission = LongSubmission.find(params[:long_submission_id])
    authorize! :submit, long_submission
    LongSubmission.transaction do
      long_submission.submission_pages.destroy_all
      long_submission.update!(submission_params)
    end
    redirect_to Contest.find(params[:contest_id]),
                notice: 'Jawaban bagian B berhasil diupload!'
  rescue ActiveRecord::ActiveRecordError
    redirect_to Contest.find(params[:contest_id]),
                alert: 'Jawaban bagian B gagal dikirim! Jika ini berlanjut, ' \
                "#{ActionController::Base.helpers.link_to 'kontak kami',
                                                          contact_path}."
  end

  def destroy_submissions
    long_submission = LongSubmission.find(params[:long_submission_id])
    authorize! :destroy_submissions, long_submission
    if long_submission.submission_pages.destroy_all
      flash[:notice] = 'Jawaban Anda berhasil dibuang!'
    else
      flash[:alert] = 'Jawaban Anda gagal dibuang! Jika ini terjadi terus, ' \
                      "#{ActionController::Base.helpers.link_to 'kontak kami',
                                                                contact_path}."
    end
    redirect_to Contest.find(params[:contest_id])
  end

  def download
    long_submission = LongSubmission.find(params[:long_submission_id])
    authorize! :download, long_submission
    long_submission.compress

    send_file long_submission.zip_location
  rescue Errno::ENOENT
    redirect_to Contest.find(params[:contest_id]), alert: 'Jawaban Anda ' \
      'tidak ditemukan! Mohon buang dan upload ulang.'
  end

  def mark
    if !@long_problem.start_mark_final && !@long_problem.all_marked? &&
       current_user.has_role?(:marker, @long_problem)
      redirect_to mark_solo_path(@long_problem)
    end
    mark
    @long_submissions = @long_submissions.includes(:user_contest)
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
    redirect_to mark_final_path(params[:id]), notice: 'Nilai berhasil diupdate!'
  end

  private

  def submission_params
    params.require(:long_submission).permit(
      submission_pages_attributes: [:page_number, :submission, :_destroy, :id]
    )
  end
end
