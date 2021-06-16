# frozen_string_literal: true

class AddVerificationAndTriesToUser < ActiveRecord::Migration
  def change
    add_column :users, :verification, :string, default: nil
    add_column :users, :enabled, :boolean, default: false
    add_column :users, :tries, :integer, default: 0
    change_column_default :users, :timezone, 'WIB'
  end
end
