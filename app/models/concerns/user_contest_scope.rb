# frozen_string_literal: true

module UserContestScope
  extend ActiveSupport::Concern
  included do
    # Show short marks on model objects. Short marks only
    # Usage: UserContest.short_marks
    scope(:short_marks, lambda {
      joins('LEFT OUTER JOIN short_submissions ON ' \
            'short_submissions.user_contest_id = user_contests.id')
      .joins('LEFT OUTER JOIN short_problems ON ' \
             'short_submissions.short_problem_id = short_problems.id')
      .group(:id)
      .select('user_contests.id, ' \
              'SUM(CASE WHEN short_submissions.answer = ' \
              'short_problems.answer THEN 1 ELSE 0 END) AS short_mark')
    })

    # Show long marks on model objects. Long marks only
    scope(:long_marks, lambda {
      joins('LEFT OUTER JOIN long_submissions ON ' \
            'long_submissions.user_contest_id = user_contests.id')
      .group(:id)
      .select('user_contests.id, ' \
              'SUM(COALESCE(long_submissions.score, 0)) AS long_mark')
    })

    # Show both short marks and long marks. Short and long marks
    scope(:include_marks, lambda {
      select('*, short_mark + long_mark AS total_mark').from(
        select('user_contests.*, short_mark, long_mark')
        .from(UserContest.short_marks, 'short_marks')
        .joins("INNER JOIN (#{UserContest.long_marks.to_sql}) long_marks " \
               'ON short_marks.id = long_marks.id')
        .joins('INNER JOIN user_contests ON short_marks.id = user_contests.id'),
        'user_contests'
      )
    })

    # Show marks + award (emas/perak/perunggu)
    scope(:processed, lambda {
      select('ucid AS id, short_mark, long_mark, total_mark, ' \
             "CASE WHEN total_mark >= gold_cutoff THEN 'Emas' " \
             "WHEN total_mark >= silver_cutoff THEN 'Perak' " \
             "WHEN total_mark >= bronze_cutoff THEN 'Perunggu' " \
             "ELSE '' END AS award")
      .from(UserContest.include_marks.joins(:contest)
                       .select('user_contests.id as ucid'), 'user_contests')
    })

    # Given a long problem ID, this shows table of user contest id
    # + long problem marks for that long problem.
    scope(:include_long_problem_marks, lambda { |long_problem_id|
      joins('LEFT OUTER JOIN long_submissions ON ' \
            'long_submissions.user_contest_id = user_contests.id')
      .where("long_submissions.long_problem_id = #{long_problem_id}")
      .select("*, long_submissions.score AS problem_no_#{long_problem_id}")
    })

    # Given a feedback question ID, this shows table of user contest id
    # + feedback answer for that feedback question. (INNER JOIN)
    scope(:include_feedback_answers, lambda { |feedback_question_id|
      joins('LEFT OUTER JOIN feedback_answers ON ' \
            'feedback_answers.user_contest_id = user_contests.id')
      .where("feedback_answers.feedback_question_id = #{feedback_question_id}")
      .select('*, feedback_answers.answer AS ' \
              "feedback_question_no_#{feedback_question_id}")
    })

    CUTOFF_CERTIFICATE = 1
    # Add this scope to filter that has high enough score to get certificates
    scope(:eligible_score, lambda {
      where("total_mark >= #{CUTOFF_CERTIFICATE}")
    })
  end
end
