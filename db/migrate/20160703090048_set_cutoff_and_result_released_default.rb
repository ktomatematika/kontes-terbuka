# frozen_string_literal: true

class SetCutoffAndResultReleasedDefault < ActiveRecord::Migration
  def change
    change_column_default :contests, :gold_cutoff, 0
    change_column_default :contests, :silver_cutoff, 0
    change_column_default :contests, :bronze_cutoff, 0
    change_column_default :contests, :result_released, false
  end
end
