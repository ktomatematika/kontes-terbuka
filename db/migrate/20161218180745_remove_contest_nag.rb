# frozen_string_literal: true

class RemoveContestNag < ActiveRecord::Migration
  def change
    remove_column :user_contests, :donation_nag
  end
end
