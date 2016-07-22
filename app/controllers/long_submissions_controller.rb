class LongSubmissionsController < ApplicationController
  def submit
    if params[:long_submission].nil?
      flash[:alert] = 'Anda tidak mengupload apapun!'
    else
      pages = params[:long_submission][:submission_pages_attributes]
              .map { |_, v| v['page_number'] }
      if pages.include? ''
        flash[:alert] = 'Jawaban bagian B gagal dikirim! ' \
        'Isi nomor halaman di setiap file yang Anda upload.'
      elsif !pages.detect { |n| pages.rindex(n) != pages.index(n) }.nil?
        flash[:alert] = 'Jawaban bagian B gagal dikirim! ' \
          'Pastikan setiap nomor halaman Anda berbeda.'
      else
        LongSubmission.transaction do
          if LongSubmission.find(params[:id]).update(submission_params)
            flash[:notice] = 'Jawaban bagian B berhasil diupload!'
          else
            flash[:alert] = 'Jawaban bagian B gagal dikirim! ' \
            'Pastikan nomor halaman di setiap soal berbeda-beda dan file-file
            yang Anda upload merupakan file PDF/zip/Word/gambar.'
          end
        end
      end
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
