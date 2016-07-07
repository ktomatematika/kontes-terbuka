class MoveSubmissionsFromUserToUserContest < ActiveRecord::Migration
  def change
    remove_column :short_submissions, :user_id
    add_column :short_submissions, :user_contest_id, :integer

    remove_column :long_submissions, :user_id
    add_column :long_submissions, :user_contest_id, :integer
  end
end
