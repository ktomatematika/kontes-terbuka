class LongProblemsController < ApplicationController
  load_and_authorize_resource

  contest_actions = [:create, :destroy_on_contest]
  before_action :load_contest, except: contest_actions
  before_action :load_contest_from_contest_params, only: [:create, :destroy_on_contest]

  def create
    if @contest.long_problems.find_by(
      problem_no: long_problem_params[:problem_no]
    ).nil?
      @contest.long_problems.create(long_problem_params).fill_long_submissions
    end
    redirect_to admin_contest_path(@contest), notice: 'Long Problem terbuat!'
  end

  def edit
  end

  def update
    if @long_problem.update(long_problem_params)
      redirect_to admin_contest_path(@contest)
    else
      render 'edit', alert: 'Esai gagal diupdate!'
    end
  end

  def destroy
    @long_problem.destroy
    Ajat.info "long_prob_destroyed|contest:#{@contest.id}|" \
    "id:#{params[:id]}"
    redirect_to admin_contest_path(@contest)
  end

  def download
    @long_problem.compress_submissions
    send_file @long_problem.zip_location
  end

  def autofill
    @long_problem.autofill
    redirect_to long_problem_long_submissions_path(@long_problem),
                notice: 'Sulap selesai!'
  end

  def start_mark_final
    @long_problem.update start_mark_final: true
    redirect_to long_problem_long_submissions_path(@long_problem),
                notice: 'Langsung diskusi!'
  end

  def upload_report
    if @long_problem.update(report_params)
      flash[:notice] = 'Laporan telah diupload!'
    else
      flash[:alert] = 'Laporan gagal diupload!'
    end
    redirect_to long_problem_long_submissions_path(@long_problem)
  end

  def destroy_on_contest
    @contest.long_problems.destroy_all
    redirect_to admin_contest_path(@contest), notice: 'Bagian B hancur!'
  end

  private

  def long_problem_params
    params.require(:long_problem).permit(:problem_no, :statement, :answer)
  end

  def report_params
    params.require(:long_problem).permit(:report)
  end

  def load_contest
    @contest = @long_problem.contest
  end

  def load_contest_from_contest_params
    @contest = Contest.find params[:contest_id]
  end
end
