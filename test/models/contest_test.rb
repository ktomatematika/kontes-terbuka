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

  end
end
