module ContestsHelper
  # This is the hash that will be used in contests#index.
  def contests_info_hash
    result = {}
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
    result
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
    unless award.empty?
      content_tag :h3, "Anda mendapatkan penghargaan #{award.downcase}!"
    end
  end

  # Helper for contests#assign_markers. This will create options for select
  # to select panitia as markers.
  def panitia_options(long_problem)
    users = User.with_role(:panitia)
                .where.not(id: User.with_role(:marker, long_problem).pluck(:id))
                .order(:username)
    options_for_select users.pluck(:username, :fullname)
                            .map { |u| ["#{u[0]} (#{u[1]})", u[0]] }
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
  def score(uc, problem_id)
    LongSubmission::SCORE_HASH[uc.send('problem_no_' + problem_id)]
  end

  # Helper for contests#_results.
  def mask_score?
    !@contest.result_released && current_user.has_role?(:marker, lp)
  end
end
