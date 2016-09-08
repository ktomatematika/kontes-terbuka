module UserContestScope
  extend ActiveSupport::Concern
  included do
    # Show short marks on model objects. Short marks only
    # Usage: UserContest.short_marks
    scope :short_marks, lambda {
      joins { short_submissions.outer }
        .joins { short_problems.outer }
        .where do
          (short_submissions.short_problem_id == short_problems.id) |
            # rubocop:disable Style/NilComparison
            ((short_submissions.short_problem_id == nil) &
             (short_problems.id == nil))
          # rubocop:enable Style/NilComparison
        end
        .group(:id)
        .select('user_contests.id as id, sum(case when ' \
        'short_submissions.answer = short_problems.answer then 1 else 0 end) ' \
        'as short_mark')
    }

    # Show long marks on model objects. Long marks only
    scope :long_marks, lambda {
      joins { long_submissions.outer }
        .group(:id)
        .select('user_contests.id as id, ' \
        'sum(coalesce(long_submissions.score, 0)) as long_mark')
    }

    # Show both short marks and long marks. Short and long marks
    scope :include_marks, lambda {
      joins { UserContest.short_marks.as(short_marks).on { id == short_marks.id } }
        .joins { UserContest.long_marks.as(long_marks).on { id == long_marks.id } }
        .select do
        ['user_contests.*', 'short_marks.short_mark',
         'long_marks.long_mark', '(short_marks.short_mark + ' \
                   'long_marks.long_mark) as total_mark']
      end
    }

    # Show marks + award (emas/perak/perunggu)
    scope :processed, lambda {
      joins { UserContest.include_marks.as(marks).on { id == marks.id } }
        .joins { contest }
        .select do
        ['user_contests.*',
         'marks.short_mark',
         'marks.long_mark',
         'marks.total_mark',
         "case when marks.total_mark >= gold_cutoff then 'Emas'
               when marks.total_mark >= silver_cutoff then 'Perak'
               when marks.total_mark >= bronze_cutoff then 'Perunggu'
               else '' end as award"]
      end.order { marks.total_mark.desc }
    }

    # Given a long problem ID, this shows table of user contest id
    # + long problem marks for that long problem.
    scope :include_long_problem_marks, lambda { |long_problem_id|
      joins { long_submissions.outer }
        .where { long_submissions.long_problem_id == long_problem_id }
        .select do
          ['user_contests.id as id', 'long_submissions.score as ' \
                     "problem_no_#{long_problem_id}"]
        end
    }

    # Add this scope to filter all that are eligible to get certificates.
    scope :can_get_certificates, lambda {
      where('total_mark >= 1')
    }
  end
end
