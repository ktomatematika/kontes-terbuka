class AddAttachmentMarkingSchemeToContests < ActiveRecord::Migration
  def self.up
    change_table :contests do |t|
      t.attachment :marking_scheme
    end
  end

  def self.down
    remove_attachment :contests, :marking_scheme
  end
end
