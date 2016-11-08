class AddUniqueIndexInReferrers < ActiveRecord::Migration
  def change
    add_index :referrers, :name, unique: true
  end
end
