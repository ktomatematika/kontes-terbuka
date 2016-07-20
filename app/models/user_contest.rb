# == Schema Information
#
# Table name: user_contests
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  contest_id   :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  donation_nag :boolean          default(TRUE), not null
#
# Indexes
#
#  index_user_contests_on_user_id_and_contest_id  (user_id,contest_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_418fd0bbd0  (contest_id => contests.id) ON DELETE => cascade
#  fk_rails_ee078c9177  (user_id => users.id) ON DELETE => cascade
#

class UserContest < ActiveRecord::Base
  has_paper_trail
  belongs_to :user
  belongs_to :contest

  has_many :short_submissions
  has_many :short_problems, through: :short_submissions

  has_many :long_submissions
  has_many :long_problems, through: :long_submissions
  has_many :submission_pages, through: :long_submissions

  has_many :feedback_answers
  has_many :feedback_questions, through: :feedback_answers

  enforce_migration_validations

  attr_accessor :rank

  def contest_points
    award = UserContest.processed.find(self.id).award

    points = 0

    points += 4 if award == 'Emas'
    points += 3 if award == 'Perak'
    points += 2 if award == 'Perunggu'

    points += 1 if short_submissions.select { |ss| ss.answer == '' }.empty?

    points += long_submissions.inject(0) do |memo, item|
      case item.score
      when nil then memo
      when 0..7 then memo + 1
      else memo + 2
      end

      points
    end

    points += 1 if short_submissions.all? { |ss| !ss.answer.empty? }
    points
  end

  # Show short marks on model objects. Short marks only
  # Usage: UserContest.short_marks
  scope :short_marks, lambda {
    joins { short_submissions.outer }
      .joins { short_problems.outer }
      .where { (short_submissions.short_problem_id == short_problems.id) |
               ((short_submissions.short_problem_id == nil) &
                (short_problems.id == nil)) }
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
    end
      .order { marks.total_mark.desc }
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
end
