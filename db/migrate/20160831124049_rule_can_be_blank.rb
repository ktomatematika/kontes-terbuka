class RuleCanBeBlank < ActiveRecord::Migration
  def change
    change_column_null :contests, :rule, true
  end
end
