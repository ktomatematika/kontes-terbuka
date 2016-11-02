class ContestsController < ApplicationController
  def admin
    @contest = Contest.find(params[:contest_id])
    authorize! :admin, @contest

    grab_problems
    @feedback_questions = @contest.feedback_questions
    Ajat.info "admin|uid:#{current_user.id}|uname:#{current_user}|" \
    "contest_id:#{params[:contest_id]}"
  end

  def new
    @contest = Contest.new
  end

  def create
    contest = Contest.new(contest_params)
    authorize! :create, contest
    if contest.save
      Ajat.info "contest_created|id:#{contest.id}"
      redirect_to contest, notice: "#{contest} berhasil dibuat!"
    else
      Ajat.warn "contest_created_fail|#{contest.errors.full_messages}"
      render 'new', alert: 'Kontes gagal dibuat!'
    end
  end

  def show
    @contest = Contest.find(params[:id])
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
    @contests = Contest.all
  end

  def edit
    @contest = Contest.find(params[:id])
    authorize! :edit, @contest
  end

  def update
    contest = Contest.find(params[:id])
    if can? :update, contest
      if contest.update(contest_params)
        Ajat.info "contest_updated|id:#{contest.id}"
        redirect_to contest, notice: "#{contest} berhasil diubah."
      else
        Ajat.warn "contest_update_fail|#{contest.errors.full_messages}"
        redirect_to contest, alert: "#{contest} gagal diubah!"
      end
    elsif can? :upload_ms, contest
      if contest.update(marking_scheme_params)
        Ajat.info "marking_scheme_uploaded|id:#{contest.id}"
        redirect_to contest, notice: "#{contest} berhasil diubah."
      else
        Ajat.warn "marking_scheme_upload_fail|#{contest.errors.full_messages}"
        redirect_to contest, alert: "#{contest} gagal diubah!"
      end
    else
      raise CanCan::AccessDenied.new('Cannot update', :update, contest)
    end
  end

  def destroy
    contest = Contest.find(params[:id])
    authorize! :destroy, contest
    contest.destroy
    Ajat.warn "contest_destroyed|#{contest}"
    redirect_to contests_path, notice: 'Kontes berhasil dihilangkan!'
  end

  def download_pdf
    contest = Contest.find(params[:contest_id])
    authorize! :download_pdf, contest

    send_file contest.problem_pdf.path
  end

  def download_marking_scheme
    contest = Contest.find(params[:contest_id])
    authorize! :download_marking_scheme, contest

    send_file contest.marking_scheme.path
  end

  def read_problems
    c = Contest.find(params[:contest_id])
    authorize! :read_problems, c
    c.update(problem_tex: params[:problem_tex])
    TexReader.new(c, params[:answers].split(',')).run
    redirect_to admin_contest_path, notice: 'TeX berhasil dibaca!'
  end

  def summary
    @contest = Contest.find(params[:contest_id])
    authorize! :summary, @contest

    @scores = @contest.array_of_scores
    @count = @scores.inject(&:+)
    redirect_to contest_path(@contest), notice: 'Tidak ada data' if @count.zero?

    grab_problems
  end

  def download_results
    @contest = Contest.find(params[:contest_id])
    authorize! :download_results, @contest

    if @contest.result_released?
      @user_contests = @contest.results(user: :roles) # this is a big query
    end

    grab_problems

    respond_to do |format|
      format.html
      format.pdf { render pdf: "Hasil #{@contest}", orientation: 'Landscape' }
    end
  end

  private

  def submission_params
    params.require(:short_answer)
  end

  def contest_params
    params.require(:contest).permit(:name, :start_time, :end_time, :result_time,
                                    :feedback_time, :problem_pdf, :gold_cutoff,
                                    :silver_cutoff, :bronze_cutoff,
                                    :result_released, :marking_scheme)
  end

  def marking_scheme_params
    params.require(:contest).permit(:marking_scheme)
  end

  def participate_params
    params.require(:user_contest).permit(:user_id, :contest_id)
  end

  def contest_from_params
    Contest.find(params[:contest_id])
  end

  def grab_problems
    @short_problems = @contest.short_problems.order('problem_no')
    @long_problems = @contest.long_problems.order('problem_no')
    @no_short_probs = @short_problems.empty?
  end
end
