class ValidateOrderInContests < ActiveRecord::Migration
  def change
    validates :contests, :start_time,
              custom: { statement: 'start_time < end_time' }
    validates :contests, :end_time,
              custom: { statement: 'end_time < result_time' }
    validates :contests, :result_time,
              custom: { statement: 'result_time < feedback_time' }
    validates :contests, :result_released,
              custom: { statement: '(not result_released) or end_time <= now()' }
  end
end
