class CreateLongProblems < ActiveRecord::Migration
  def change
    create_table :long_problems do |t|

      t.belongs_to :contest, index: true
      t.integer :problem_no
      t.text :statement
      t.timestamps null: false
    end
  end
end
