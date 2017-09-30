# frozen_string_literal: true

module ProblemTimesValidation
  extend ActiveSupport::Concern

  validate :start_time_after_contest_start_time
  validate :end_time_before_contest_end_time
  validate :start_time_before_end_time

  def start_time_after_contest_start_time
    return if start_time.nil? || start_time >= contest.start_time
    errors.add :start_time, 'must be >= contest start time'
  end

  def end_time_before_contest_end_time
    return if end_time.nil? || end_time <= contest.end_time
    errors.add :end_time, 'must be <= contest end time'
  end

  def start_time_before_end_time
    return if start_time.nil? || end_time.nil? || start_time < end_time
    errors.add :start_time, 'must be < end time'
  end
end
