# frozen_string_literal: true

class CreateLongSubmissions < ActiveRecord::Migration
  def change
    create_table :long_submissions do |t|
      t.belongs_to :user
      t.belongs_to :long_problem
      t.timestamps null: false
    end
  end
end
