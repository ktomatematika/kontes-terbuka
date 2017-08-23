# frozen_string_literal: true

module ContestsHelper
  # This is the hash that will be used in contests#index.
  def contests_info_hash
    {}.tap do |result|
      @contests.each do |c|
        result[c.id] = {
          name: c.name,
          start_time: c.start_time,
          end_time: c.end_time,
          number_of_short_questions: ShortProblem.where(contest: c).length,
          number_of_long_questions: LongProblem.where(contest: c).length,
          path: contest_path(c)
        }
      end
    end
  end

  # Helper for contests#contest_aside_info.
  def aside_display_unanswered(problem_no)
    content_tag :div, "No. #{problem_no}: belum terjawab", class: 'text-danger'
  end

  # Helper for contests#contest_aside_info.
  def aside_display_answered(problem_no, answer)
    content_tag :div, "No. #{problem_no}: #{answer}"
  end

  # Helper for contests#own_results, to show award.
  def show_award
    award = @user_contest.award
    return if award.empty?
    content_tag :h3, "Anda mendapatkan penghargaan #{award.downcase}!"
  end

  # Helper for contests#assign_markers. This will create options for select
  # to select panitia as markers.
  def panitia_options(long_problem)
    users = User.with_role(:panitia)
                .where.not(id: User.with_role(:marker, long_problem).pluck(:id))
                .order(:username)
    options_for_select(users.pluck(:username, :fullname)
                            .map { |u| ["#{u[0]} (#{u[1]})", u[0]] })
  end

  # Helper for contests#summary.
  def average(sum)
    sum = 0 if sum.nil?
    sum.to_f / @count
  end

  # Helper for contests#summary.
  def percentage(num)
    number_to_percentage num * 100, precision: 2
  end

  # Helper for contests#_own_results and contests#_results.
  def score(user_contest, long_problem)
    LongSubmission::SCORE_HASH[user_contest.__send__(
      'problem_no_' + long_problem.id.to_s
    )]
  end

  # Helper for contests#_results.
  def mask_score?(long_problem)
    !@contest.result_released && current_user.has_cached_role?(:marker,
                                                               long_problem)
  end

  # Helper for contests#summary, so that one knows whether one can see the
  # scores summary or not.
  def can_see_summary?
    @contest.result_released == true ||
      @long_problems.map { |lp| mask_score? lp }.none?
  end

  # Helper for contests#summary. Determines the average mark of a problem
  # to be shown in summary.
  def average_mark(long_submissions)
    count = long_submissions.where.not(score: nil).count
    if count.zero?
      0
    else
      (long_submissions.sum(:score).to_f / count).round(2)
    end
  end

  # Helper for contests#_own_results.
  def score_out_of_total(lp)
    score(@user_contest, lp).to_s + '/' + LongProblem::MAX_MARK.to_s + ' poin'
  end

  # helper for contests#give_feedback, where it shows the message when
  # a criteria is unfulfilled.
  def certificate_criteria_unfulfilled_message
    if UserContest.processed.eligible_score.find_by(id: @user_contest.id).nil?
      "Maaf, karena nilai Anda di bawah #{UserContest::CUTOFF_CERTIFICATE}, " \
        'Anda tidak akan mendapatkan sertifikat.'
    elsif @contest.full_feedback_user_contests
                  .find_by(id: @user_contest.id).nil?
      'Anda belum menjawab semua pertanyaan di bawah ini.'
    end
  end

  # Helper for contests#long_problems, similar to find_or_initialize_by
  # while avoiding the n + 1 query.
  def long_submission_find_or_initialize_by(long_problem)
    @long_submissions.find { |ls| ls.long_problem == long_problem } ||
      LongSubmission.new(user_contest: @user_contest,
                         long_problem: long_problem)
  end

  # Helper for contests#_own_results to show green or red depending on
  # whether the short submission is correct or wrong.
  def status(ss, sp)
    return '' if ss.nil?
    return 'text-success' if ss.answer == sp.answer
    'text-danger'
  end
end
