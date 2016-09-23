# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: submission_pages
#
#  id                      :integer          not null, primary key
#  page_number             :integer          not null
#  long_submission_id      :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  submission_file_name    :string
#  submission_content_type :string
#  submission_file_size    :integer
#  submission_updated_at   :datetime
#
# Indexes
#
#  index_submission_pages_on_page_number_and_long_submission_id  (page_number,long_submission_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_62bec7c828  (long_submission_id => long_submissions.id) ON DELETE => cascade
#
# rubocop:enable Metrics/LineLength
