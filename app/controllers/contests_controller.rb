class ContestsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource only: :update

  def admin
    grab_problems
    @feedback_questions = @contest.feedback_questions
    Ajat.info "admin|uid:#{current_user.id}|uname:#{current_user}|" \
    "contest_id:#{params[:contest_id]}"
  end

  def new
  end

  def create
    if @contest.save
      Ajat.info "contest_created|id:#{@contest.id}"
      redirect_to @contest, notice: "#{@contest} berhasil dibuat!"
    else
      Ajat.warn "contest_created_fail|#{@contest.errors.full_messages}"
      render 'new', alert: 'Kontes gagal dibuat!'
    end
  end

  def show
    @mask = false

    if @contest.currently_in_contest?
      @user_contest = @contest.user_contests.find_by(user: current_user)
      redirect_to contest_rules_path(params[:id]) if @user_contest.nil?
    else
      @user_contests = @contest.results(user: :roles) # this is a big query
      @user_contest = @user_contests.find { |uc| uc.user == current_user }

      if cannot? :view_all, @contest
        @user_contests = @user_contests.reject { |uc| uc.award.empty? }
      end
    end

    grab_problems
  end

  def index
  end

  def edit
  end

  def update
    if can? :update, @contest
      if @contest.update(contest_params)
        Ajat.info "contest_updated|id:#{@contest.id}"
        redirect_to @contest, notice: "#{@contest} berhasil diubah."
      else
        Ajat.warn "contest_update_fail|#{@contest.errors.full_messages}"
        redirect_to @contest, alert: "#{@contest} gagal diubah!"
      end
    elsif can? :upload_ms, @contest
      if @contest.update(marking_scheme_params)
        Ajat.info "marking_scheme_uploaded|id:#{@contest.id}"
        redirect_to @contest, notice: "#{@contest} berhasil diubah."
      else
        Ajat.warn "marking_scheme_upload_fail|#{@contest.errors.full_messages}"
        redirect_to @contest, alert: "#{@contest} gagal diubah!"
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

  def download_pdf
    send_file @contest.problem_pdf.path
  end

  def download_marking_scheme
    send_file @contest.marking_scheme.path
  end

  def read_problems
    @contest.update(problem_tex: params[:problem_tex])
    TexReader.new(@contest, params[:answers].split(',')).run
    redirect_to admin_contest_path(@contest), notice: 'TeX berhasil dibaca!'
  end

  def summary
    @scores = @contest.array_of_scores
    @count = @scores.inject(&:+)
    redirect_to contest_path(@contest), notice: 'Tidak ada data' if @count.zero?

    grab_problems
  end

  def download_results
    @user_contests = @contest.results(user: :roles)
    grab_problems

    respond_to do |format|
      format.html
      format.pdf { render pdf: "Hasil #{@contest}", orientation: 'Landscape' }
    end
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
