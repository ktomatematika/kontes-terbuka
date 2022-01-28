# frozen_string_literal: true

class TokenCantBeBlank < ActiveRecord::Migration
  def change
    change_column_null :user_notifications, :token, false
  end
end
