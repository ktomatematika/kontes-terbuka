# frozen_string_literal: true

module UserContestScope
  extend ActiveSupport::Concern
  included do
    # Show short marks on model objects. Short marks only
    # Usage: UserContest.short_marks
    scope(:short_marks, lambda {
      joins('LEFT OUTER JOIN short_submissions ON \
    short_submissions.user_contest_id = user_contests.id')
      .joins('LEFT OUTER JOIN short_problems ON \
    short_submissions.short_problem_id = short_problems.id')
      .group(:id)
      .select('user_contests.id, SUM(CASE WHEN \
    short_submissions.answer = short_problems.answer \
    THEN 1 ELSE 0 END) AS short_mark')
    })

    # Show long marks on model objects. Long marks only
    scope(:long_marks, lambda {
      joins { long_submissions.outer }
        .group(:id)
        .select('user_contests.id as id, ' \
        'sum(coalesce(long_submissions.score, 0)) as long_mark')
    })

    # Show both short marks and long marks. Short and long marks
    scope(:include_marks, lambda {
      sm = joins do
        UserContest.short_marks.as(short_marks).on { id == short_marks.id }
      end
      short_and_long_marks = sm.joins do
        UserContest.long_marks.as(long_marks).on { id == long_marks.id }
      end
      short_and_long_marks.select do
        ['user_contests.*', 'short_marks.short_mark',
         'long_marks.long_mark', '(short_marks.short_mark + ' \
                   'long_marks.long_mark) as total_mark']
      end
    })

    # Show marks + award (emas/perak/perunggu)
    scope(:processed, lambda {
      included = joins do
        UserContest.include_marks.as(marks).on { id == marks.id }
      end
      included.joins { contest }
              .select do
        ['user_contests.*',
         'marks.short_mark',
         'marks.long_mark',
         'marks.total_mark',
         "case when marks.total_mark >= gold_cutoff then 'Emas'
               when marks.total_mark >= silver_cutoff then 'Perak'
               when marks.total_mark >= bronze_cutoff then 'Perunggu'
               else '' end as award"]
      end
    })

    # Given a long problem ID, this shows table of user contest id
    # + long problem marks for that long problem.
    scope(:include_long_problem_marks, lambda { |long_problem_id|
      joins { long_submissions.outer }
        .where { long_submissions.long_problem_id == long_problem_id }
        .select do
          ['user_contests.id as id', 'long_submissions.score as ' \
                     "problem_no_#{long_problem_id}"]
        end
    })

    # Given a feedback question ID, this shows table of user contest id
    # + feedback answer for that feedback question. (INNER JOIN)
    scope(:include_feedback_answers, lambda { |feedback_question_id|
      joins { feedback_answers }
        .where { feedback_answers.feedback_question_id == feedback_question_id }
        .select do
          ['user_contests.id as id', 'feedback_answers.answer as ' \
                     "feedback_question_no_#{feedback_question_id}"]
        end
    })

    CUTOFF_CERTIFICATE = 1
    # Add this scope to filter that has high enough score to get certificates
    scope(:eligible_score, lambda {
      where("total_mark >= #{CUTOFF_CERTIFICATE}")
    })
  end
end
