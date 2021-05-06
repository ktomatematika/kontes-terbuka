class ChangeNullableAnswer < ActiveRecord::Migration
    def change
      change_column_null :short_submissions, :answer, true
    end
  end