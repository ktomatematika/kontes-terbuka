# frozen_string_literal: true

class EnforceValidationsInDatabaseLevel < ActiveRecord::Migration
  def change
    remove_column :contests, :type
    change_column :contests, :rule, :text, null: false
  end
end
