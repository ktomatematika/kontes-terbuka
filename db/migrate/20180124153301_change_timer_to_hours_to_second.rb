class ChangeTimerToHoursToSecond < ActiveRecord::Migration
  def change
    execute 'ALTER TABLE contests ALTER COLUMN timer TYPE interval HOUR TO SECOND;'
  end
end
