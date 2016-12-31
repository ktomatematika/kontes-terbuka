class AddOlimpiadeOrgLinks < ActiveRecord::Migration
  def change
    add_column :contests, :forum_link, :string
    add_column :long_problems, :forum_link, :string
  end
end
