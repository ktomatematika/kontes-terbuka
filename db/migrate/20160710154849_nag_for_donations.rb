class NagForDonations < ActiveRecord::Migration
  def change
    add_column :user_contests, :donation_nag, :boolean, default: true
  end
end
