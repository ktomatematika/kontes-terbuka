class FixLegacy < ActiveRecord::Migration
  def change
    remove_index :colors, name: 'idx_mv_colors_name_uniq'
    add_index :colors, :name, unique: true
    remove_index :provinces, name: 'idx_mv_provinces_name_uniq'
    add_index :provinces, :name, unique: true
    remove_index :statuses, name: 'idx_mv_statuses_name_uniq'
    add_index :statuses, :name, unique: true
  end
end
