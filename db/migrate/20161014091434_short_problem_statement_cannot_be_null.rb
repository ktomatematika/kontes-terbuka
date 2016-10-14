class ShortProblemStatementCannotBeNull < ActiveRecord::Migration
  def change
    change_column_null :short_problems, :statement, false, ''
    change_column_default :short_problems, :statement, ''
  end
end
