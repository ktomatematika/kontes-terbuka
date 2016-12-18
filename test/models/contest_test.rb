# == Schema Information
#
# Table name: contests
#
#  id                          :integer          not null, primary key
#  name                        :string           not null
#  start_time                  :datetime         not null
#  end_time                    :datetime         not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  problem_pdf_file_name       :string
#  problem_pdf_content_type    :string
#  problem_pdf_file_size       :integer
#  problem_pdf_updated_at      :datetime
#  rule                        :text             default("")
#  result_time                 :datetime         not null
#  feedback_time               :datetime         not null
#  gold_cutoff                 :integer          default(0), not null
#  silver_cutoff               :integer          default(0), not null
#  bronze_cutoff               :integer          default(0), not null
#  result_released             :boolean          default(FALSE), not null
#  problem_tex_file_name       :string
#  problem_tex_content_type    :string
#  problem_tex_file_size       :integer
#  problem_tex_updated_at      :datetime
#  marking_scheme_file_name    :string
#  marking_scheme_content_type :string
#  marking_scheme_file_size    :integer
#  marking_scheme_updated_at   :datetime
#
# Indexes
#
#  index_contests_on_end_time       (end_time)
#  index_contests_on_feedback_time  (feedback_time)
#  index_contests_on_result_time    (result_time)
#  index_contests_on_start_time     (start_time)
#
# rubocop:enable Metrics/LineLength

require 'test_helper'

class ContestTest < ActiveSupport::TestCase
  test 'contest can be saved' do
    assert build(:contest).save, 'Contest cannot be saved'
  end

  test 'default rule is from assets/default_rules.txt' do
    assert_equal create(:contest).rule,
                 File.open('app/assets/default_rules.txt', 'r').read,
                 'Contest cannot be saved'
  end

  test 'contest associations' do
    assert_equal Contest.reflect_on_association(:user_contests).macro,
                 :has_many,
                 'Contest does not have many user contests.'
    assert_equal Contest.reflect_on_association(:short_problems).macro,
                 :has_many,
                 'Contest does not have many short problems.'
    assert_equal Contest.reflect_on_association(:long_problems).macro,
                 :has_many,
                 'Contest does not have many long problems.'
    assert_equal Contest.reflect_on_association(:feedback_questions).macro,
                 :has_many,
                 'Contest does not have many feedback questions.'
  end

  test 'attachments' do
    c = build(:contest, problem_pdf: PDF)
    assert c.save, 'Contest with PDF problem cannot be created.'
    assert File.exist?(Rails.root.join('public', 'contest_files', 'problems',
                                       c.id.to_s, 'soal.pdf')),
           'PDF problem file is not uploaded.'
    assert_not build(:contest, problem_pdf: TEX).save,
               'Contest with invalid problem PDF can be saved.'

    c = build(:contest, marking_scheme: PDF)
    assert c.save, 'Contest with valid marking scheme cannot be created.'
    assert File.exist?(Rails.root.join('public', 'contest_files', 'problems',
                                       c.id.to_s, 'ms.pdf')),
           'Marking scheme is not uploaded.'
    c = build(:contest, problem_tex: TEX)
    assert c.save, 'Contest with TeX problem cannot be created.'
    assert File.exist?(Rails.root.join('public', 'contest_files', 'problems',
                                       c.id.to_s, 'soal.tex')),
           'TeX problem file is not uploaded.'
    assert_not build(:contest, problem_tex: PDF).save,
               'Contest with invalid problem PDF can be saved.'
  end

  test 'name must exist' do
    assert_not build(:contest, name: nil).save,
               'Contest with no name can be saved.'
  end

  test 'end time must exist' do
    assert_not build(:contest, end_time: nil).save,
               'Contest with no end time can be saved.'
  end

  test 'start time must exist' do
    assert_not build(:contest, start_time: nil).save,
               'Contest with no start time can be saved.'
  end

  test 'result time must exist' do
    assert_not build(:contest, result_time: nil).save,
               'Contest with no result time can be saved.'
  end

  test 'feedback time must exist' do
    assert_not build(:contest, feedback_time: nil).save,
               'Contest with no feedback time can be saved.'
  end

  test 'cutoffs' do
    c = create(:contest)
    assert_equal c.gold_cutoff, 0,
                 'Contest does not have zero gold cutoff as default.'
    assert_equal c.silver_cutoff, 0,
                 'Contest does not have zero silver cutoff as default.'
    assert_equal c.bronze_cutoff, 0,
                 'Contest does not have zero bronze cutoff as default.'

    assert_not build(:contest, gold_cutoff: nil).save,
               'Contest with nil gold cutoff can be saved.'
    assert_not build(:contest, silver_cutoff: nil).save,
               'Contest with nil silver cutoff can be saved.'
    assert_not build(:contest, bronze_cutoff: nil).save,
               'Contest with nil bronze cutoff can be saved.'
  end

  test 'result released cannot be nil' do
    assert_not build(:contest, result_released: nil).save,
               'Contest with nil result released can be saved.'
  end

  test 'start time must be before end time' do
    assert_not build(:contest, start_time: Time.zone.now,
                               end_time: Time.zone.now - 10.seconds).save,
               'Contest with start time > end time can be saved.'
  end

  test 'end time must be before result time' do
    assert_not build(:contest, start_time: Time.zone.now,
                               end_time: Time.zone.now + 10.seconds,
                               result_time: Time.zone.now + 5.seconds).save,
               'Contest with end time > result time can be saved.'
  end

  test 'result time must be before feedback time' do
    assert_not build(:contest, start: 0, ends: 10,
                               result: 20, feedback: 15).save,
               'Contest with result time > feedback time can be saved.'
  end

  test 'result can only be released after contest ended' do
    c = create(:contest, ends: 10)
    assert_not c.update(result_released: true),
               'Contest that has not ended can have results released'
  end

  test 'next contest returns next smallest contest end time' do
    create(:contest, start: -5, ends: -3)
    c = create(:contest, ends: 5)
    create(:contest, ends: 10)
    create(:contest, ends: 20)
    assert_equal Contest.next_contest.id, c.id,
                 'Next contest does not return the contest with smallest ' \
  'end time from now'
  end

  test 'next important contest returns closest feedback or end time' do
    c = create(:contest, start: -5, ends: -3, feedback: 45)
    assert_equal Contest.next_important_contest.id, c.id,
                 'Next important contest does not return closest ' \
                 'end/feedback time'
  end

  test 'next important contest returns closest feedback or end time 2' do
    create(:contest, ends: 30, feedback: 45)
    c = create(:contest, start: -5, ends: -3, result: 20, feedback: 25)
    assert_equal Contest.next_important_contest.id, c.id,
                 'Next important contest does not return closest ' \
                 'end/feedback time'
  end

  test 'next important contest returns closest feedback or end time 3' do
    create(:contest, ends: 30, feedback: 45)
    c = create(:contest, ends: 20, feedback: 90)
    assert_equal Contest.next_important_contest.id, c.id,
                 'Next important contest does not return closest ' \
                 'end/feedback time'
  end

  test 'contest to string follows its name' do
    assert_equal create(:contest, name: 'asdf').to_s, 'asdf',
                 'Contest to_s does not equal its name.'
  end

  test 'contest params is ID, dash, name with only lowercase letters,
  numbers and dashes' do
    c1 = create(:contest, name: 'Kontes halo')
    c2 = create(:contest, name: 'kontes!@#$%^&*23')
    c3 = create(:contest, name: 'aSdFgHjK')
    c4 = create(:contest, name: 'q  e  r')
    c5 = create(:contest, name: '234234kontes asal_aja')

    assert_equal c1.to_param, "#{c1.id}-kontes-halo",
                 "#{c1} become #{c1.to_param}."
    assert_equal c2.to_param, "#{c2.id}-kontes23",
                 "#{c2} become #{c2.to_param}."
    assert_equal c3.to_param, "#{c3.id}-asdfghjk",
                 "#{c3} become #{c3.to_param}."
    assert_equal c4.to_param, "#{c4.id}-q--e--r",
                 "#{c4} become #{c4.to_param}."
    assert_equal c5.to_param, "#{c5.id}-234234kontes-asalaja",
                 "#{c5} become #{c5.to_param}."
  end

  test 'contest helper methods' do
    c1 = create(:contest, start: -40, ends: -20, result: -10, feedback: -5)
    c2 = create(:contest, start: -40, ends: -20, result: -10, feedback: 40)
    c3 = create(:contest, start: -40, ends: -20, result: 30, feedback: 40)
    c4 = create(:contest, start: -40, ends: -20, result: 30, feedback: 40)
    c5 = create(:contest, start: -40, ends: 20, result: 30, feedback: 40)
    c6 = create(:contest, start: 10, ends: 20, result: 30, feedback: 40)

    assert c1.started?, 'started helper method fail'
    assert c2.started?, 'started helper method fail'
    assert c3.started?, 'started helper method fail'
    assert c4.started?, 'started helper method fail'
    assert c5.started?, 'started helper method fail'
    assert_not c6.started?, 'started helper method fail'

    assert c1.ended?, 'ended helper method fail'
    assert c2.ended?, 'ended helper method fail'
    assert c3.ended?, 'ended helper method fail'
    assert c4.ended?, 'ended helper method fail'
    assert_not c5.ended?, 'ended helper method fail'
    assert_not c6.ended?, 'ended helper method fail'

    assert c1.feedback_closed?, 'feedback_closed helper method fail'
    assert_not c2.feedback_closed?, 'feedback_closed helper method fail'
    assert_not c3.feedback_closed?, 'feedback_closed helper method fail'
    assert_not c4.feedback_closed?, 'feedback_closed helper method fail'
    assert_not c5.feedback_closed?, 'feedback_closed helper method fail'
    assert_not c6.feedback_closed?, 'feedback_closed helper method fail'

    assert_not c1.currently_in_contest?,
               'currently_in_contest helper method fail'
    assert_not c2.currently_in_contest?,
               'currently_in_contest helper method fail'
    assert_not c3.currently_in_contest?,
               'currently_in_contest helper method fail'
    assert_not c4.currently_in_contest?,
               'currently_in_contest helper method fail'
    assert c5.currently_in_contest?, 'currently_in_contest helper method fail'
    assert_not c6.currently_in_contest?,
               'currently_in_contest helper method fail'
  end

  test 'max score' do
    c1 = create(:contest)
    c2 = create(:contest)

    10.times.each do |i|
      create(:short_problem, contest: c1, problem_no: i + 1)
    end
    7.times.each do |i|
      create(:long_problem, contest: c1, problem_no: i + 1)
    end
    5.times.each do |i|
      create(:short_problem, contest: c2, problem_no: i + 1)
    end
    3.times.each do |i|
      create(:long_problem, contest: c2, problem_no: i + 1)
    end

    assert_equal c1.max_score, 10 + LongProblem::MAX_MARK * 7
    assert_equal c2.max_score, 5 + LongProblem::MAX_MARK * 3
  end

  test 'compress_reports' do
    c = create(:full_contest)
    c.long_problems.each { |lp| lp.update(report: PDF) }
    c.compress_reports
    assert File.file?(c.report_zip_location), 'Zip file does not exist.'

    Zip::File.open(c.report_zip_location) do |file|
      assert_equal file.count, c.long_problems.count,
                   'Number of files does not match long problems!'

      file.each do |f|
        assert_equal f.size, PDF.size, 'Report is tampered!'
      end
    end
  end

  test 'report_zip_location' do
    c = create(:contest)
    create(:long_problem, contest: c, report: PDF)
    c.compress_reports
    assert_equal c.report_zip_location,
                 Rails.root.join('public', 'contest_files',
                                 'reports', "#{c.id}.zip").to_s,
                 'Report zip location is not correct.'
  end

  test 'compress_submissions' do
    c = create(:full_contest, long_problems: 1)

    count = 0
    c.long_problems.each do |lp|
      lp.long_submissions.each do |ls|
        ls.submission_pages.each do |pg|
          pg.update(submission: PDF)
          count += 1
        end
      end
    end
    c.compress_submissions
    assert File.file?(c.submissions_zip_location), 'Zip file does not exist.'

    Zip::File.open(c.submissions_zip_location) do |file|
      assert_equal file.select(&:file?).count, count,
                   'Number of files does not match submission pages'

      file.each do |f|
        assert_equal(f.size, PDF.size, 'Submission is tampered!') if f.file?
      end
    end
  end

  test 'submission_zip_location' do
    c = create(:full_contest)
    c.long_problems.take.long_submissions.take.submission_pages.take
     .update(submission: PDF)
    c.compress_submissions
    assert_equal c.submissions_zip_location,
                 Rails.root.join('public', 'contest_files',
                                 'submissions', "kontes#{c.id}.zip").to_s,
                 'Submission zip location is not correct.'
  end

  test 'contest complex methods' do
    c = create(:full_contest, short_problems: 1, long_problems: 1,
                              users: 5, gold_cutoff: 6,
                              silver_cutoff: 4, bronze_cutoff: 2)
    c.short_problems.take.update(answer: '23')
    ucs = UserContest.all

    ucs.first.short_submissions.take.update(answer: '23')
    ucs.second.short_submissions.take.update(answer: '23')
    ucs.third.short_submissions.take.update(answer: '3')
    ucs.fourth.short_submissions.take.update(answer: '3')
    ucs.fifth.short_submissions.take.update(answer: '3')

    ucs.first.long_submissions.take.update(score: nil)
    ucs.second.long_submissions.take.update(score: 2)
    ucs.third.long_submissions.take.update(score: 4)
    ucs.fourth.long_submissions.take.update(score: 6)
    ucs.fifth.long_submissions.take.update(score: 6)

    rucs = c.results

    assert_equal rucs.first.short_mark, 0
    assert_equal rucs.first.long_mark, 6
    assert_equal rucs.first.total_mark, 6
    assert_equal rucs.first.award, 'Emas'
    assert_equal rucs.first.rank, 1

    assert_equal rucs.second.short_mark, 0
    assert_equal rucs.second.long_mark, 6
    assert_equal rucs.second.total_mark, 6
    assert_equal rucs.second.award, 'Emas'
    assert_equal rucs.second.rank, 1

    assert_equal rucs.third.short_mark, 0
    assert_equal rucs.third.long_mark, 4
    assert_equal rucs.third.total_mark, 4
    assert_equal rucs.third.award, 'Perak'
    assert_equal rucs.third.rank, 3

    assert_equal rucs.fourth.short_mark, 1
    assert_equal rucs.fourth.long_mark, 2
    assert_equal rucs.fourth.total_mark, 3
    assert_equal rucs.fourth.award, 'Perunggu'
    assert_equal rucs.fourth.rank, 4

    assert_equal rucs.fifth.short_mark, 1
    assert_equal rucs.fifth.long_mark, 0
    assert_equal rucs.fifth.total_mark, 1
    assert_equal rucs.fifth.award, ''
    assert_equal rucs.fifth.rank, 5

    rucs.third.user.add_role :veteran
    assert_equal c.array_of_scores, [0, 1, 0, 1, 0, 0, 2, 0, 0]
  end

  test 'contest jobs' do
    c = build(:contest, start: 3 * 24 * 3600, ends: 6 * 24 * 3600,
                        result: 9 * 24 * 3600, feedback: 12 * 24 * 3600,
                        result_released: false)
    10.times do
      create(:contest).delay(queue: "contest_#{c.id}").reload # do nothing
    end

    c.save
    jobs = Delayed::Job.where(queue: "contest_#{c.id}").map do |j|
      handler = YAML.load(j.handler)
      { class: handler.object.class.name, run_at: j.run_at,
        method_name: handler.method_name, args: handler.args }
    end

    assert_equal jobs.select { |j| j[:method_name] == :reload }.count, 0,
                 'prepared jobs are not destroyed.'

    purge = jobs.select { |j| j[:method_name] == :purge_panitia }
    assert_equal purge.count, 1, 'panitia are not purged.'
    assert_in_delta purge.first[:run_at], c.end_time, 5,
                    'purge panitia is not run at end time.'
    assert_equal purge.first[:args].count, 0,
                 'purge panitia args are not correct.'

    starting = jobs.select do |j|
      j[:method_name] == :contest_starting && j[:class] == 'EmailNotifications'
    end
    starting.each do |j|
      n = Notification.find_by event: 'contest_starting',
                               description: j[:args].first +
                                            ' sebelum kontes dimulai'
      assert_not_nil n
      assert_in_delta n.seconds, c.start_time - j[:run_at], 5,
                      'email notifications are not working'
    end

    started = jobs.select do |j|
      j[:method_name] == :contest_started && j[:class] == 'EmailNotifications'
    end
    started.each do |j|
      n = Notification.find_by event: 'contest_started'
      assert_not_nil n
      assert_in_delta j[:run_at], c.start_time, 5,
                      'email notifications are not working'
    end

    ending = jobs.select do |j|
      j[:method_name] == :contest_ending && j[:class] == 'EmailNotifications'
    end
    ending.each do |j|
      n = Notification.find_by event: 'contest_ending',
                               description: j[:args].first +
                                            ' sebelum kontes selesai'
      assert_not_nil n
      assert_in_delta n.seconds, c.end_time - j[:run_at], 5,
                      'email notifications are not working'
    end

    feedback = jobs.select do |j|
      j[:method_name] == :feedback_ending && j[:class] == 'EmailNotifications'
    end
    feedback.each do |j|
      n = Notification.find_by event: 'feedback_ending',
                               description: j[:args].first +
                                            ' sebelum feedback dibagikan'
      assert_not_nil n
      assert_in_delta n.seconds, c.feedback_time - j[:run_at], 5,
                      'email notifications are not working'
    end

    line = jobs.select { |j| j[:class] == 'LineNag' }
    assert_equal line.select { |j| j[:method_name] == :contest_starting }.count,
                 1
    assert_equal line.select { |j| j[:method_name] == :contest_started }.count,
                 1
    assert_equal line.select { |j| j[:method_name] == :contest_ending }.count, 1

    facebook = jobs.select { |j| j[:class] == 'FacebookPost' }
    assert_equal(facebook.select do |j|
      j[:method_name] == :contest_starting
    end.count, 1)
    assert_equal(facebook.select do |j|
      j[:method_name] == :contest_started
    end.count, 1)
    assert_equal(facebook.select do |j|
      j[:method_name] == :contest_ending
    end.count, 1)
    assert_equal(facebook.select do |j|
      j[:method_name] == :feedback_ending
    end.count, 1)

    [:check_veteran, :award_points, :send_certificates,
     :certificate_sent].each do |method|
      job = jobs.select { |j| j[:method_name] == method }
      assert_equal job.count, 1
      assert_in_delta job.first[:run_at], c.feedback_time, 5
    end

    [:backup_misc, :backup_submissions].each do |method|
      job = jobs.select do |j|
        j[:method_name] == method && (c.feedback_time - j[:run_at]).abs <= 5
      end
      assert_equal job.count, 1
>>>>>>> f965b6e... update for new tests
    end

    c.update(start_time: Time.zone.now - 10.days,
             end_time: Time.zone.now - 5.days,
             result_released: true)
    update_time = Time.zone.now

    jobs = Delayed::Job.where(queue: "contest_#{c.id}").map do |j|
      handler = YAML.load(j.handler)
      { class: handler.object.class.name, run_at: j.run_at,
        method_name: handler.method_name, args: handler.args }
    end
  end

  test 'feedback and user contests finder methods' do
    c = create(:contest)
    ucs = create_list(:user_contest, 3, contest: c)
    fqs = create_list(:feedback_question, 3, contest: c)

    create(:feedback_answer, feedback_question: fqs.first,
                             user_contest: ucs.third)
    fqs.each do |fq|
      create(:feedback_answer, feedback_question: fq, user_contest: ucs.first)
    end

    assert_equal c.full_feedback_user_contests.pluck(:id), [ucs.first.id],
                 'Full feedback user contests is not working!'

<<<<<<< HEAD
    assert_equal c.not_full_feedback_user_contests.order(:id).pluck(:id),
                 [ucs.second.id, ucs.third.id].sort,
                 'Not full feedback user contests is not working!'
=======
    [['EmailNotifications', :results_released],
     ['LineNag', :result_and_next_contest],
     ['FacebookPost', :results_released]].each do |arr|
      job = jobs.select do |j|
        j[:class] == arr[0] && j[:method_name] == arr[1] &&
          (update_time - j[:run_at]).abs <= 5
      end
      assert_equal job.count, 1
    end
>>>>>>> f965b6e... update for new tests
  end
end
