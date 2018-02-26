class RemoveStartMarkFinal < ActiveRecord::Migration
  def change
    remove_column :long_problems, :start_mark_final
  end
end
