class RemoveHandphoneFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :handphone, :string
  end
end
