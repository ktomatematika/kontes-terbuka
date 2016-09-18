class FixLegacy < ActiveRecord::Migration
  def change
    if index_exists? :statuses, :name, name: 'idx_mv_statuses_name_uniq'
      remove_index :statuses, name: 'idx_mv_statuses_name_uniq'
    end
    add_index :statuses, :name, unique: true

    if index_exists? :provinces, :name, name: 'idx_mv_provinces_name_uniq'
      remove_index :provinces, name: 'idx_mv_provinces_name_uniq'
    end

    add_index :provinces, :name, unique: true
    if index_exists? :statuses, :name, name: 'idx_mv_statuses_name_uniq'
      remove_index :statuses, name: 'idx_mv_statuses_name_uniq'
    end

    add_index :statuses, :name, unique: true

    if index_exists? :users, :username, name: 'idx_mv_users_username_uniq'
      remove_index :users, 'idx_mv_users_username_uniq'
    end
    if index_exists? :users, :email, name: 'idx_mv_users_email_uniq'
      remove_index :users, 'idx_mv_users_email_uniq'
    end
    if index_exists? :users, :verification,
      name: 'idx_mv_users_verification_uniq'
      remove_index :users, 'idx_mv_users_verification_uniq'
    end
    if index_exists? :users, :auth_token, name: 'idx_mv_users_auth_token_uniq'
      remove_index :users, 'idx_mv_users_auth_token_uniq'
    end
  end
end
