# frozen_string_literal: true

class ChangeShortProblemsAnswer < ActiveRecord::Migration
  def up
    change_table :short_problems do |t|
      t.change :answer, :string
    end
  end

  def down
    change_table :short_problems do |t|
      t.change :answer, :integer
    end
  end
end
