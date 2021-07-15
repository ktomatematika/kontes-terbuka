# frozen_string_literal: true

class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
