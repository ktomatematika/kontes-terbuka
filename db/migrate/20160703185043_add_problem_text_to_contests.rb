class AddProblemTextToContests < ActiveRecord::Migration
  def self.up
    change_table :contests do |t|
      t.attachment :problem_tex
    end
  end

  def self.down
    remove_attachment :contests, :problem_tex
  end
end