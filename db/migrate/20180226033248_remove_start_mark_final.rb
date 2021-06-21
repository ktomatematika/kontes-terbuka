# frozen_string_literal: true

class RemoveStartMarkFinal < ActiveRecord::Migration
  def change
    remove_column :long_problems, :start_mark_final
  end
end
