# frozen_string_literal: true

class AddColorRefToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :color, index: true, foreign_key: true
  end
end
