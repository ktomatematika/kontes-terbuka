# frozen_string_literal: true

class AddDefaultToFeedback < ActiveRecord::Migration
  def change
    change_column :long_submissions, :feedback, :string, default: ''
  end
end
