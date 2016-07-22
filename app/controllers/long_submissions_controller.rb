class LongSubmissionsController < ApplicationController
  def submit
    LongSubmission.transaction do
      if LongSubmission.find(params[:id]).update(submission_params)
        flash[:notice] = 'Jawaban bagian B berhasil diupload!'
      else
        flash[:alert] = 'Jawaban bagian B gagal diupload! Pastikan nomor
        halaman di setiap soal berbeda-beda dan file-file yang Anda upload
        merupakan file PDF/zip/Word/gambar.'
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
