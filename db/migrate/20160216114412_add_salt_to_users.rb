# frozen_string_literal: true

class AddSaltToUsers < ActiveRecord::Migration
  def change
    add_column :users, :salt, :string
  end
end
