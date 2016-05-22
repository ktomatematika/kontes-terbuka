class AddAttachmentSubmissionToLongSubmissions < ActiveRecord::Migration
  def self.up
    change_table :long_submissions do |t|
      t.attachment :submission
    end
  end

  def self.down
    remove_attachment :long_submissions, :submission
  end
end
