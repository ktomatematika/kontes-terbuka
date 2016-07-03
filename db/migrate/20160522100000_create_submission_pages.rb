class CreateSubmissionPages < ActiveRecord::Migration
  def change
    create_table :submission_pages do |t|
      t.integer :page_number
      t.integer :long_submission_id
      t.timestamps null: false
    end
  end
end
