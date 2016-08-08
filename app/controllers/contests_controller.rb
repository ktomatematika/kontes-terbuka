class ContestsController < ApplicationController
  def grab_problems
    @short_problems = @contest.short_problems
                              .order('problem_no')
                              .includes(short_submissions: :user_contest)
    @long_problems = @contest.long_problems
                             .order('problem_no')
                             .includes(long_submissions: :user_contest)
  end

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
    authorize! :admin, contest
    if contest.save
      Ajat.info "contest_created|id:#{contest.id}"
      contest.prepare_jobs
      redirect_to contest, notice: "#{contest} berhasil dibuat!"
    else
      Ajat.warn "contest_created_fail|#{contest.errors.full_messages}"
      render 'new', alert: 'Kontes gagal dibuat!'
    end
  end

  def show
    @contest = Contest.find(params[:id])

    if @contest.currently_in_contest?
      @user_contest = @contest.user_contests
                              .includes([short_submissions: :short_problem],
                                        [long_submissions: :long_problem])
                              .find_by(user: current_user)
      redirect_to contest_rules_path(params[:id]) if @user_contest.nil?
    else
      @user_contests = @contest.results # this is a big query
      @user_contest = @user_contests.find { |uc| uc.user == current_user }
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
    authorize! :update, contest
    if contest.update(contest_params)
      Ajat.info "contest_updated|id:#{contest.id}"
      redirect_to contest, notice: "#{contest} berhasil diubah."
    else
      Ajat.warn "contest_update_fail|#{contest.errors.full_messages}"
      render 'edit', alert: "#{contest} gagal diubah!"
    end
  end

  def destroy
    contest = Contest.find(params[:id])
    authorize! :destroy, contest
    contest.destroy
    Ajat.warn "contest_destroyed|#{contest}"
    redirect_to contests_path, notice: 'Kontes berhasil dihilangkan!'
  end

  def show_rules
    @contest = Contest.find(params[:contest_id])
    @user_contest = UserContest.find_by(contest: @contest,
                                        user: current_user) ||
                    UserContest.new
  end

  def accept_rules
    contest = Contest.find(participate_params[:contest_id])

    if contest.currently_in_contest?
      UserContest.transaction do
        user_contest = UserContest.find_or_create_by(participate_params)
        contest.long_problems.each do |long_problem|
          LongSubmission.create(user_contest: user_contest,
                                long_problem: long_problem)
        end
      end
    end

    redirect_to contest
  end

  def create_short_submissions
    contest_id = params['contest_id']
    contest = Contest.find(contest_id)
    authorize! :create_short_submissions, contest
    submission_params.each_key do |prob_id|
      answer = submission_params[prob_id]
      next if answer == ''
      user_contest = UserContest.find_by(user: current_user, contest: contest)
      ShortSubmission.find_or_initialize_by(short_problem_id: prob_id,
                                            user_contest: user_contest)
                     .update(answer: answer)
    end
    redirect_to contest, notice: 'Jawaban bagian A berhasil dikirimkan!'
  end

  def give_feedback
    @contest = Contest.find(params[:contest_id])
    authorize! :give_feedback, @contest
    @feedback_questions = @contest.feedback_questions
  end

  def feedback_submit
    contest = Contest.find(params[:contest_id])
    authorize! :feedback_submit, contest
    user_contest = UserContest.find_by(user: current_user, contest: contest)
    feedback_params.each_key do |q_id|
      answer = feedback_params[q_id]
      next if answer == ''
      FeedbackAnswer.find_or_create_by(feedback_question_id: q_id,
                                       user_contest: user_contest)
                    .update(answer: answer)
    end
    redirect_to contest, notice: 'Feedback berhasil dikirimkan! ' \
                                 'Jika nilai Anda minimal satu poin, Anda ' \
                                 'akan mendapatkan sertifikat setelah waktu ' \
                                 'feedback ditutup.'
  end

  def assign_markers
    @contest = Contest.find(params[:id])
    authorize! :assign_markers, @contest
    @long_problems = LongProblem.where(contest: @contest).order(:problem_no)
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

  def download_feedback
    @contest = Contest.find(params[:contest_id])
    authorize! :download_feedback, @contest
    @feedback_questions = @contest.feedback_questions.include(:user_contests)
                                  .order(:id)
    @user_contests = @contest.user_contests.joins(:feedback_answers).group(:id)
    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] =
          "attachment; filename=\"Feedback #{@contest}\".csv"
        headers['Content-Type'] ||= 'text/csv'
      end
    end
    Ajat.info "feedback_downloaded|contest_id:#{@contest.id}"
  end

  def download_certificate
    contest = Contest.find params[:contest_id]
    authorize! :download_certificate, contest

    uc = UserContest.find_by user: current_user, contest: contest
    certificate_obj = CertificateManager.new(uc.id)
    pdf_file = certificate_obj.create_and_give

    send_file pdf_file
    certificate_obj.clean_files
  end

  def give_points
    contest = Contest.find(params[:contest_id])
    authorize! :give_points, contest
    contest.user_contests.each do |uc|
      PointTransaction.create!(point: uc.contest_points, description: contest)
    end
    Ajat.info "point_given|contest_id:#{contest.id}"
    redirect_to contest, notice: 'Point sudah dibagi-bagi~'
  end

  def read_problems
    c = Contest.find(params[:contest_id])
    authorize! :read_problems, c
    c.update(problem_tex: params[:problem_tex])
    TexReader.new(c, params[:answers].split(',')).run
  end

  def summary
    @contest = Contest.find(params[:contest_id])
    authorize! :summary, @contest

    @scores = @contest.array_of_scores
    @count = @scores.inject(&:+)
    redirect_to contest_path(@contest), notice: 'Tidak ada data' if @count.zero?

    @short_problems = @contest.short_problems.order(:problem_no)
    @long_problems = @contest.long_problems.order(:problem_no)
  end

  private

  def submission_params
    params.require(:short_answer)
  end

  def feedback_params
    params.require(:feedback_answer)
  end

  def contest_params
    params.require(:contest).permit(:name, :start_time, :end_time, :result_time,
                                    :feedback_time, :problem_pdf, :gold_cutoff,
                                    :silver_cutoff, :bronze_cutoff,
                                    :result_released, :marking_scheme)
  end

  def participate_params
    params.require(:user_contest).permit(:user_id, :contest_id)
  end
end
