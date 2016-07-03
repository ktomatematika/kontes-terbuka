class SetCutoffAndResultReleasedDefault < ActiveRecord::Migration
  def change
    validates :contests, :gold_cutoff, null: false
    change_column_default :contests, :gold_cutoff, 0
    validates :contests, :silver_cutoff, null: false
    change_column_default :contests, :silver_cutoff, 0
    validates :contests, :bronze_cutoff, null: false
    change_column_default :contests, :bronze_cutoff, 0
    validates :contests, :result_released, null: false
    change_column_default :contests, :result_released, false
  end
end
