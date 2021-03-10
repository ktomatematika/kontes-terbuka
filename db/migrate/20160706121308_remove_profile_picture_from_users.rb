# frozen_string_literal: true

class RemoveProfilePictureFromUsers < ActiveRecord::Migration
  def change
    remove_attachment :users, :profile_picture
  end
end
