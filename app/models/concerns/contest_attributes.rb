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

  def max_score
    ShortProblem.where(contest_id: id).sum(:correct_score) + LongProblem.where(contest_id: id).sum(:max_score)
  end

  def results
    scores.select { 'RANK() OVER(ORDER BY marks.total_mark DESC) AS rank' }
  end

  # This method generates an array containing the number of people getting
  # a certain total score, excluding veterans.
  def array_of_scores
    res = Array.new(max_score + 1).fill(0)
    scores.includes(user: :roles).find_each do |uc|
      res[uc.total_mark] += 1 unless uc.user.has_cached_role?(:veteran)
    end
    res
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
      hash[fq.id] = '' if hash[fq.id].nil?
    end

    [].tap do |res|
      hash.each_value do |h|
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
    filtered_query = user_contests.processed.order { marks.total_mark.desc }

    long_problems.each do |l|
      joined = filtered_query.joins do
        UserContest.include_long_problem_marks(l.id)
                   .as("long_problem_marks_#{l.id}")
                   .on { id == __send__("long_problem_marks_#{l.id}").id }.outer
      end
      filtered_query = joined.select do
        __send__("long_problem_marks_#{l.id}").__send__("problem_no_#{l.id}")
      end
    end
    filtered_query
  end
end
