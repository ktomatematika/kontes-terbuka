class AddColorToUsers < ActiveRecord::Migration
  def change
    add_column :users, :color, :integer
  end
end
