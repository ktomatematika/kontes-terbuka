class AddAttachmentProblemPdfToContests < ActiveRecord::Migration
  def self.up
    change_table :contests do |t|
      t.attachment :problem_pdf
    end
  end

  def self.down
    remove_attachment :contests, :problem_pdf
  end
end
