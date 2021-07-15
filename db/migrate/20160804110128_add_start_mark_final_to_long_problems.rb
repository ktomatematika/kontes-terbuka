# frozen_string_literal: true

class AddStartMarkFinalToLongProblems < ActiveRecord::Migration
  def change
    add_column :long_problems, :start_mark_final, :boolean, default: false
  end
end
