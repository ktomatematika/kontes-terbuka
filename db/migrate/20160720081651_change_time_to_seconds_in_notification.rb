class ChangeTimeToSecondsInNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :seconds, :integer
  end
end
