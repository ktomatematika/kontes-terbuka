# frozen_string_literal: true

class AddTimerToUserContests < ActiveRecord::Migration
  def change
    add_column :user_contests, :end_time, :datetime
  end
end
