class LongSubmissionsController < ApplicationController
  def submit
    begin
      pages = params[:long_submission][:submission_pages_attributes]
              .map { |_, v| v['page_number'] }
      if !pages.detect { |n| pages.rindex(n) != pages.index(n) }.nil?
        flash[:alert] = 'Jawaban bagian B gagal dikirim! ' \
          'Pastikan setiap nomor halaman Anda berbeda.'
      elsif LongSubmission.find(params[:id]).update!(submission_params)
        flash[:notice] = 'Jawaban bagian B berhasil diupload!'
      end
    rescue ActiveRecord::ActiveRecordError
      flash[:alert] = 'Jawaban bagian B gagal dikirim! Jika ini berlanjut, ' \
        "#{ActionController::Base.helpers.link_to 'kontak kami', contact_path}."
    end
    redirect_to Contest.find(params[:contest_id])
  end

  private

  def submission_params
    params.require(:long_submission).permit(
      submission_pages_attributes: [:page_number, :submission, :_destroy, :id]
    )
  end
end
