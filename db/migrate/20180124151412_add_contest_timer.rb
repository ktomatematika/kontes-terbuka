# frozen_string_literal: true

class AddContestTimer < ActiveRecord::Migration
  def change
    add_column :contests, :timer, :interval
  end
end
