class ContestsController < ApplicationController
  load_resource
  authorize_resource except: :update

  def admin
    grab_problems
    @feedback_questions = @contest.feedback_questions
    Ajat.info "admin|uid:#{current_user.id}|uname:#{current_user}|" \
    "contest_id:#{params[:contest_id]}"
  end

  def new; end

  def create
    if @contest.save
      Ajat.info "contest_created|id:#{@contest.id}"
      redirect_to contest_path(@contest), notice: "#{@contest} berhasil dibuat!"
    else
      Ajat.warn "contest_created_fail|#{@contest.errors.full_messages}"
      render 'new', alert: 'Kontes gagal dibuat!'
    end
  end

  def show
    if @contest.currently_in_contest?
      @user_contest = UserContest.find_by(contest: @contest, user: current_user)
      if @user_contest.nil?
        redirect_to new_contest_user_contest_path(@contest)
      else
        @short_submissions = @user_contest.short_submissions
        @long_submissions = @user_contest.long_submissions
      end
    elsif @contest.result_released || can?(:preview, @contest)
      @mask = false # agak gimanaaa gitu

      # This is a big query
      @user_contests = @contest.results(user: [:roles, :province])
      @same_province_ucs = @user_contests.select do |uc|
        uc.user.province_id == current_user.province_id
      end
      @user_contests = @user_contests.where('marks.total_mark >= bronze_cutoff')

      @user_contest = @user_contests.find { |uc| uc.user == current_user }
      if @user_contest
        @long_submissions = @user_contest.long_submissions
                                         .includes(:long_problem)
        @short_submissions = @user_contest.short_submissions
                                          .includes(:short_problem)
      end

      grab_problems
    end
  end

  def index; end

  def update
    if can? :update, @contest
      if @contest.update(contest_params)
        Ajat.info "contest_updated|id:#{@contest.id}"
        redirect_to contest_path(@contest), notice: "#{@contest} berhasil " \
          'diubah.'
      else
        Ajat.warn "contest_update_fail|#{@contest.errors.full_messages}"
        redirect_to admin_contest_path(@contest),
                    alert: "#{@contest} gagal diubah!"
      end
    elsif can? :upload_ms, @contest
      if @contest.update(marking_scheme_params)
        Ajat.info "marking_scheme_uploaded|id:#{@contest.id}"
        redirect_to contest_path(@contest),
                    notice: "#{@contest} berhasil diubah."
      else
        Ajat.warn "marking_scheme_upload_fail|#{@contest.errors.full_messages}"
        redirect_to admin_contest_path(@contest),
                    alert: "#{@contest} gagal diubah!"
      end
    else
      raise CanCan::AccessDenied.new('Cannot update', :update, @contest)
    end
  end

  def destroy
    @contest.destroy
    Ajat.warn "contest_destroyed|#{@contest}"
    redirect_to contests_path, notice: 'Kontes berhasil dihilangkan!'
  end

  def download_problem_pdf
    send_file @contest.problem_pdf.path
  rescue Errno::ENOENT
    redirect_to @contest, alert: 'File belum ada!'
  end

  def download_marking_scheme
    send_file @contest.marking_scheme.path
  rescue Errno::ENOENT
    redirect_to admin_contest_path(@contest), alert: 'File belum ada!'
  end

  def download_reports
    @contest.compress_reports
    send_file @contest.report_zip_location
  rescue Errno::ENOENT
    redirect_to admin_contest_path(@contest), alert: 'File belum ada!'
  end

  def read_problems
    t = TexReader.new(@contest, params[:answers].split(','),
                      params[:problem_tex])
    params[:compile_only] ? t.compile_tex : t.run
    redirect_to admin_contest_path(@contest), notice: 'TeX berhasil dibaca!'
  end

  def summary
    @scores = @contest.array_of_scores
    @count = @scores.inject(&:+)
    redirect_to contest_path(@contest), notice: 'Tidak ada data' if @count.zero?

    grab_problems
  end

  def download_results
    send_file @contest.results_location, disposition: :inline,
                                         filename: "Hasil #{@contest}.pdf"
  rescue ActionController::MissingFile
    @contest.refresh_results_pdf
    retry
  end

  def refresh
    @contest.refresh
    redirect_to contest_path(@contest), notice: 'Refreshed!'
  end

  def refresh
    @contest.refresh
    redirect_to admin_contest_path(@contest)
                notice: 'Refreshed!'
  end

  private

  def contest_params
    params.require(:contest).permit(:name, :start_time, :end_time, :result_time,
                                    :feedback_time, :problem_pdf, :gold_cutoff,
                                    :silver_cutoff, :bronze_cutoff,
                                    :result_released, :marking_scheme)
  end

  def marking_scheme_params
    params.require(:contest).permit(:marking_scheme)
  end

  def grab_problems
    @short_problems = @contest.short_problems.order('problem_no')
    @long_problems = @contest.long_problems.order('problem_no')
    @no_short_probs = @short_problems.empty?
  end
end
