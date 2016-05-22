class ChangeShortSubmissionsAnswer < ActiveRecord::Migration
  def up
    change_table :short_submissions do |t|
      t.change :answer, :string
    end
  end
 
  def down
    change_table :short_submissions do |t|
      t.change :answer, :integer
    end
  end
end
