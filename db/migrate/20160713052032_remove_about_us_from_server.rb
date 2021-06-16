# frozen_string_literal: true

class RemoveAboutUsFromServer < ActiveRecord::Migration
  def change
    drop_table :about_us_entries
  end
end
