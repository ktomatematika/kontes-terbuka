class RemoveLinkToOlimpiadeOrg < ActiveRecord::Migration
  def change
    remove_column :contests, :forum_link, :string
    remove_column :long_problems, :forum_link, :string
  end
end
