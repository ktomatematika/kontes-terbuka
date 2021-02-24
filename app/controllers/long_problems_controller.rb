# frozen_string_literal: true

class LongProblemsController < ApplicationController
  load_resource
  authorize_resource

  contest_actions = %i[create destroy_on_contest]
  before_action :load_contest, except: contest_actions

  def create
    if @contest.long_problems.create(long_problem_params)
      flash[:notice] = 'Long Problem terbuat!'
    else
      flash[:alert] = 'Long Problem gagal terbuat!'
    end
    redirect_to admin_contest_path(@contest)
  end

  def edit; end

  def update
    %i[start_time end_time].each do |param|
      if params[:long_problem][:"#{param}_is_nil"] == 1
        @long_problem.update(param => nil)
      else
        @long_problem.update(param => params[:long_problem][param])
      end
    end

    if @long_problem.update(long_problem_params)
      redirect_to admin_contest_path(@contest)
    else
      flash.now[:alert] = 'Esai gagal diupdate!'
      render 'edit'
    end
  end

  def destroy
    @long_problem.destroy
    Ajat.info "long_prob_destroyed|contest:#{@contest.id}|" \
    "id:#{params[:id]}"
    redirect_to admin_contest_path(@contest)
  end

  def download_submissions
    @long_problem.compress_submissions
    send_file @long_problem.zip_location
  end

  def autofill
    @long_problem.autofill
    redirect_to long_problem_long_submissions_path(@long_problem),
                notice: 'Sulap selesai!'
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

  private def long_problem_params
    params.require(:long_problem).permit(:problem_no, :statement, :max_score) 
  end

  private def report_params
    params.require(:long_problem).permit(:report)
  end

  private def load_contest
    @contest = @long_problem.contest
  end
end
