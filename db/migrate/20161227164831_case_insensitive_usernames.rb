# frozen_string_literal: true

class CaseInsensitiveUsernames < ActiveRecord::Migration
  def change
    execute 'UPDATE users SET username = lower(username);'
    execute 'ALTER TABLE users ADD CONSTRAINT users_username_lowercase_check ' \
      'CHECK (username = lower(username));'
  end
end
