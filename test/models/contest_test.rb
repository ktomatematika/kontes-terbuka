# == Schema Information
#
# Table name: contests
#
#  id                       :integer          not null, primary key
#  name                     :string
#  start_time               :datetime
#  end_time                 :datetime
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  problem_pdf_file_name    :string
#  problem_pdf_content_type :string
#  problem_pdf_file_size    :integer
#  problem_pdf_updated_at   :datetime
#  rule                     :text             default(""), not null
#  result_time              :datetime
#  feedback_time            :datetime
#  gold_cutoff              :integer          default(0)
#  silver_cutoff            :integer          default(0)
#  bronze_cutoff            :integer          default(0)
#  result_released          :boolean          default(FALSE)
#  problem_tex_file_name    :string
#  problem_tex_content_type :string
#  problem_tex_file_size    :integer
#  problem_tex_updated_at   :datetime
#

require 'test_helper'

class ContestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # needs title
  # title is not empty
  # needs short questions
  # short questions can be 0
  # needs long questions
  # long questions can be 0
  # needs start time
  # needs end time
  # start time must < end time (strictly)
end
