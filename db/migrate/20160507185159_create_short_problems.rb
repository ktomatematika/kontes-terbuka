class CreateShortProblems < ActiveRecord::Migration
  def change
    create_table :short_problems do |t|
   	  t.belongs_to :contest, index: true
      t.integer :problem_no
      t.string :statement
      t.integer :answer
      t.timestamps null: false
    end
  end
end
