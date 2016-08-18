class NotNullInPointTransactionPoints < ActiveRecord::Migration
  def change
    change_column_null :point_transactions, :point, false, 0
  end
end
