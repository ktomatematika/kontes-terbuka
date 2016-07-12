class AddDescriptionToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :description, :string
    validates :notifications, :description, presence: true
  end
end
