# frozen_string_literal: true

class AddTimezoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :timezone, :string
  end
end
