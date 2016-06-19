class CreateShortSubmissions < ActiveRecord::Migration
  def change
    create_table :short_submissions do |t|
      t.belongs_to :user
      t.belongs_to :short_problem
      t.integer :answer
      t.timestamps null: false
    end
  end
end
