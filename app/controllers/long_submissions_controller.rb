# frozen_string_literal: true

class LongSubmissionsController < ApplicationController
  load_resource :long_problem
  load_resource :long_submission
  authorize_resource :long_submission, except: :create

  def create
    @long_submission.long_problem = @long_problem
    @long_submission.user_contest_id = params[:user_contest_id]
    @long_submission.submission_pages.each do |sp|
      sp.long_submission = @long_submission
    end

    authorize! :create, @long_submission

    if !@long_submission.submission_pages.empty? && @long_submission.save
      redirect_to :back, notice: 'Jawaban bagian B berhasil diupload!'
    else
      redirect_to :back,
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
    redirect_to :back
  end

  def download
    @long_submission.compress
    send_file @long_submission.zip_location
  rescue Errno::ENOENT, ActionController::MissingFile
    redirect_to :back, alert: 'Jawaban Anda tidak ditemukan! Mohon buang ' \
                'dan upload ulang.'
  end

  def mark
    @long_submissions = @long_problem.long_submissions
                                     .order(:user_contest_id)
                                     .includes(:user_contest)
    @markers = User.with_role :marker, @long_problem
    @contest = @long_problem.contest
  end

  def submit_mark
    params[:marking].each do |id, val|
      feedback = (val[:comment] + ' ' + val[:suggestion]).strip
      #score = LongSubmission::SCORE_HASH.key(val[:score])
      score = LongSubmission.find(id).get_text_score(val[:score])

      update_hash = { score: score, feedback: feedback }
      update_hash.delete(:score) if val[:score].empty?
      update_hash.delete(:feedback) if feedback.empty?

      LongSubmission.find(id).update(update_hash)
    end
    redirect_to long_problem_long_submissions_path(@long_problem),
                notice: 'Nilai berhasil diupdate!'
  end

  def new
    @long_problem = LongProblem.find_by(contest_id: params[:contest_id],
                                        problem_no: params[:problem_no])
    return unless @long_problem
    user = User.find_by(username: params[:username])
    contest = Contest.find(params[:contest_id])
    @user_contest = UserContest.find_by(user: user, contest: contest)
    @long_submission = LongSubmission.find_or_initialize_by(
      user_contest: @user_contest, long_problem: @long_problem
    )
  end

  private def long_submission_params
    params.fetch(:long_submission, {}).permit(
      submission_pages_attributes: %i[page_number submission _destroy id]
    )
  end
end
