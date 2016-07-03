class AddLongSubmissionForeignKeyToSubmissionPages < ActiveRecord::Migration
  def change
    add_foreign_key :submission_pages, :long_submissions
  end
end
