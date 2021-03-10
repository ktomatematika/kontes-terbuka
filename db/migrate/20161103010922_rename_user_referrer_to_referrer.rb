# frozen_string_literal: true

class RenameUserReferrerToReferrer < ActiveRecord::Migration
  def self.up
    rename_table :user_referrers, :referrers
    rename_column :users, :user_referrer_id, :referrer_id
  end

  def self.down
    rename_table :referrers, :user_referrers
    rename_column :users, :referrer_id, :user_referrer_id
  end
end
