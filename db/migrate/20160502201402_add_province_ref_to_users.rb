class AddProvinceRefToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :province, index: true, foreign_key: true
  end
end
