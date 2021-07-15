# frozen_string_literal: true

class RevertRulesDefaultValue < ActiveRecord::Migration
  def change
    change_column :contests, :rule, :text, default: ''
  end
end
