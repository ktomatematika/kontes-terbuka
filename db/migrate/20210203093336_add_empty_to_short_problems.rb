class AddEmptyToShortProblems < ActiveRecord::Migration
  def change
    add_column :short_problems, :empty, :integer, default: 0
  end
end
