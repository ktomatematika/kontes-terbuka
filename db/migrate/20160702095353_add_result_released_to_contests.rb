# frozen_string_literal: true

class AddResultReleasedToContests < ActiveRecord::Migration
  def change
    add_column :contests, :result_released, :boolean
  end
end
