class CreateLongSubmissions < ActiveRecord::Migration
  def change
    create_table :long_submissions do |t|
      t.string :name
      t.string :attachment
      t.integer :problem_id

      t.timestamps null: false
    end
  end
end
