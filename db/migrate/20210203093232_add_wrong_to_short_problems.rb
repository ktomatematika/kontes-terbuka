class AddWrongToShortProblems < ActiveRecord::Migration
  def change
    add_column :short_problems, :wrong, :integer, default: 0
  end
end
