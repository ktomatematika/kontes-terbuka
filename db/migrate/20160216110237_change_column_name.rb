# frozen_string_literal: true

class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :users, :password, :hashed_password
  end
end
