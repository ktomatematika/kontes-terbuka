# frozen_string_literal: true

class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
