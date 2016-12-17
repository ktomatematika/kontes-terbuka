class AddUserReferrerToUser < ActiveRecord::Migration
  def change
    add_column :users, :user_referrer_id, :integer
    add_index :users, :user_referrer_id
  end
end
