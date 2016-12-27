class AddGinIndexToUsers < ActiveRecord::Migration
  def change
    enable_extension 'pg_trgm'
    add_index :users, :username, using: :gin,
      name: 'index_users_on_username_gin',
      order: { username: :gin_trgm_ops }
  end
end
