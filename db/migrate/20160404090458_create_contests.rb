# frozen_string_literal: true

class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.string :name
      t.string :type
      t.integer :number_of_short_questions
      t.integer :number_of_long_questions
      t.datetime :start_time
      t.datetime :end_time
      t.datetime :created_on
      t.datetime :last_updated_on

      t.timestamps null: false
    end
  end
end
