# frozen_string_literal: true

class AddNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :event
      t.string :time
      t.string :time_text
      t.timestamps null: false
    end

    create_table :user_notifications do |t|
      t.integer :user_id, null: false
      t.integer :notification_id, null: false
      t.timestamps null: false
    end
  end
end
