class AddContestTimer < ActiveRecord::Migration
  def change
    add_column :contests, :timer, :interval
  end
end
