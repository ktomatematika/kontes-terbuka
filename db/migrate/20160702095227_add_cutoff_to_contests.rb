class AddCutoffToContests < ActiveRecord::Migration
  def change
    add_column :contests, :gold_cutoff, :integer
    add_column :contests, :silver_cutoff, :integer
    add_column :contests, :bronze_cutoff, :integer
  end
end
