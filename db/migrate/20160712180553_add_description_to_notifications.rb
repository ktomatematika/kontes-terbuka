# frozen_string_literal: true

class AddDescriptionToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :description, :string
  end
end
