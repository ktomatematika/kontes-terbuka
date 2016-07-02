class AddRuleToContests < ActiveRecord::Migration
  def change
    add_column :contests, :rule, :text
  end
end
