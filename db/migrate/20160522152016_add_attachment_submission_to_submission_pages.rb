# frozen_string_literal: true

class AddAttachmentSubmissionToSubmissionPages < ActiveRecord::Migration
  def self.up
    change_table :submission_pages do |t|
      t.attachment :submission
    end
  end

  def self.down
    remove_attachment :submission_pages, :submission
  end
end
