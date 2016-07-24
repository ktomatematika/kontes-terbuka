class LongSubmissionsController < ApplicationController
  after_action do
    authorize! params[:action].to_sym, @long_submission || LongSubmission
  end

  def submit
    @long_submission = LongSubmission.find(params[:long_submission_id])
    LongSubmission.transaction do
      @long_submission.submission_pages.destroy_all
      @long_submission.update!(submission_params)
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
    @long_submission = LongSubmission.find(params[:long_submission_id])
    if @long_submission.submission_pages.destroy_all
      flash[:notice] = 'Jawaban Anda berhasil dibuang!'
    else
      flash[:alert] = 'Jawaban Anda gagal dibuang! Jika ini terjadi terus, ' \
                      "#{ActionController::Base.helpers.link_to 'kontak kami',
                                                                contact_path}."
    end
    redirect_to Contest.find(params[:contest_id])
  end

  def download
    @long_submission = LongSubmission.find(params[:long_submission_id])
    @long_submission.compress
    send_file @long_submission.zip_location, type: 'application/zip',
                                             disposition: 'attachment'
  rescue Errno::ENOENT
    redirect_to Contest.find(params[:contest_id]), alert: 'Jawaban Anda ' \
      'tidak ditemukan! Mohon buang dan upload ulang.'
  end

  private

  def submission_params
    params.require(:long_submission).permit(
      submission_pages_attributes: [:page_number, :submission, :_destroy, :id]
    )
  end
end
