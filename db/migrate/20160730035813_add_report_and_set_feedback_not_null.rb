# frozen_string_literal: true

class AddReportAndSetFeedbackNotNull < ActiveRecord::Migration
  def change
    add_attachment :long_problems, :report
    change_column_null :long_submissions, :feedback, false, ''
  end
end
