class CreateAboutUsEntries < ActiveRecord::Migration
  def change
    create_table :about_us_entries do |t|
      t.string :name
      t.text :description
      t.attachment :photo
    end
  end
end
