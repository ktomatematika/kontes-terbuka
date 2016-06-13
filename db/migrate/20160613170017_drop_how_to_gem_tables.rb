class DropHowToGemTables < ActiveRecord::Migration
  def change
	  drop_table :how_to_content_translations
	  drop_table :how_to_contents
	  drop_table :how_to_section_translations
	  drop_table :how_to_sections
  end
end
