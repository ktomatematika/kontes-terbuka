class LongSubmissionsController < ApplicationController
  def submit
    LongSubmission.find(params[:id]).update!(submission_params)
    redirect_to Contest.find(params[:contest_id]),
      notice: 'Jawaban bagian B berhasil diupload!'
  rescue ActiveRecord::ActiveRecordError
    redirect_to Contest.find(params[:contest_id]),
      alert: 'Jawaban bagian B gagal dikirim! Jika ini berlanjut, ' \
      "#{ActionController::Base.helpers.link_to 'kontak kami', contact_path}."
  end

  private

  def submission_params
    params.require(:long_submission).permit(
      submission_pages_attributes: [:page_number, :submission, :_destroy, :id]
    )
  end
end
