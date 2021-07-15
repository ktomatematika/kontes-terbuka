# frozen_string_literal: true

class MakeUserColumnsUnique < ActiveRecord::Migration
  def change
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
    add_index :users, :verification, unique: true
    add_index :users, :auth_token, unique: true
  end
end
