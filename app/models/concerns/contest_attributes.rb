# frozen_string_literal: true

module ContestAttributes
  extend ActiveSupport::Concern

  def to_s
    name
  end

  def to_param
    "#{id}-#{name.downcase.gsub(/[^0-9A-Za-z ]/, '').tr(' ', '-')}"
  end

  def started?
    Time.zone.now >= start_time
  end

  def ended?
    Time.zone.now >= end_time
  end

  def feedback_closed?
    Time.zone.now >= feedback_time
  end

  def currently_in_contest?
    started? && !ended?
  end

  def max_score(sp_count = short_problems.count, lp_count = long_problems.count)
    sp_count ||= short_problems.count
    lp_count ||= long_problems.count
    sp_count + LongProblem::MAX_MARK * lp_count
  end

  def results
    scores.select { 'RANK() OVER(ORDER BY total_mark DESC) AS rank' }
  end

  # This method generates an array containing the number of people getting
  # a certain total score, excluding veterans.
  def array_of_scores
    Array.new(max_score + 1).fill(0).tap do |res|
      scores.includes(user: :roles).each do |uc|
        res[uc.total_mark] += 1 unless uc.user.has_cached_role?(:veteran)
      end
    end
  end

  # Returns a matrix of feedback answers (2d array).
  # Main array is an array of answers by the same user contest ID.
  # In each sub-array there are answers sorted by feedback questions ID.
  def feedback_answers_matrix
    hash = Hash.new { |h, k| h[k] = {} }

    feedback_answers.each do |fa|
      hash[fa.user_contest_id][fa.feedback_question_id] = fa.answer
    end

    feedback_questions.each do |fq|
      hash.each { |_ucid, h| h[fq.id] = '' if h[fq.id].nil? }
    end

    [].tap do |res|
      hash.each do |_ucid, h|
        res.append(h.sort_by { |fqid, _ans| fqid }.map { |arr| arr[1] })
      end
    end
  end

  # This method finds all user_contests who fills
  # all feedback questions in that particular contest.
  def full_feedback_user_contests
    filtered_query = user_contests.processed

    feedback_questions.each do |fq|
      filtered_query =
        filtered_query
        .joins do
          UserContest.include_feedback_answers(fq.id)
                     .as("feedback_answers_#{fq.id}")
                     .on do
                       id == __send__("feedback_answers_#{fq.id}").id
                     end
        end
    end
    filtered_query
  end

  # This method finds all user_contests who has at least one feedback question
  # not filled in that particular contest.
  def not_full_feedback_user_contests
    full = full_feedback_user_contests.pluck(:id)
    all = user_contests.pluck(:id)
    remaining = all - full
    UserContest.where(id: remaining)
  end

  private def scores
    UserContest.select('*').from(part_of_scores)
      .joins("INNER JOIN (#{UserContest.processed.to_sql}) " \
             'user_contests_processed ON subquery.id = ' \
             'user_contests_processed.id')
      .joins('INNER JOIN user_contests ON subquery.id = user_contests.id')
  end

  private def part_of_scores
    source_sql = UserContest.select('user_contests.id, long_problems.id, ' \
                                    'long_submissions.score')
                 .from(user_contests.processed, 'user_contests')
                 .joins(:long_problems)
                 .order('user_contests.id, long_problems.id')
                 .to_sql.gsub("'", "''")
    category_sql = long_problems.select(:id).order(:id).to_sql
    columns_sql = '(id int' + long_problems.order(:id).pluck(:id).map do |id|
                                ", problem_no_#{id} int"
                              end.join + ')'

    UserContest.select('*').from("crosstab('#{source_sql}', " \
                                 "'#{category_sql}') AS #{columns_sql}")
  end
end
