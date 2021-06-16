# frozen_string_literal: true

class RemoveTimeFromNotifications < ActiveRecord::Migration
  def change
    remove_column :notifications, :time
  end
end
