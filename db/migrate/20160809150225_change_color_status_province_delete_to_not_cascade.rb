# frozen_string_literal: true

class ChangeColorStatusProvinceDeleteToNotCascade < ActiveRecord::Migration
  def change
    remove_foreign_key :users, :colors
    remove_foreign_key :users, :statuses
    remove_foreign_key :users, :provinces
    change_column_null :users, :status_id, true
    change_column_null :users, :province_id, true
    add_foreign_key :users, :colors, on_delete: :nullify
    add_foreign_key :users, :statuses, on_delete: :nullify
    add_foreign_key :users, :provinces, on_delete: :nullify
  end
end
