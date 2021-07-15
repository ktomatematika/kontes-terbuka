# frozen_string_literal: true

class AddRuleToContests < ActiveRecord::Migration
  def change
    add_column :contests, :rule, :text
  end
end
