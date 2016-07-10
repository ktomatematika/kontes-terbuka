class ChangeTransactionToPointTransaction < ActiveRecord::Migration
  def change
    rename_table 'transactions', 'point_transactions'
  end
end
