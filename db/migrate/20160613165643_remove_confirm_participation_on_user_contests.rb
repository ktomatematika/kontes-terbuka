class RemoveConfirmParticipationOnUserContests < ActiveRecord::Migration
  def change
    remove_column :user_contests, :confirm_participation, :boolean
  end
end
