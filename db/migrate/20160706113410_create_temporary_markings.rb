class CreateTemporaryMarkings < ActiveRecord::Migration
  def change
    create_table :temporary_markings do |t|
      t.belongs_to :user, index: true
      t.belongs_to  :long_submission, index: true
      t.integer :mark
      t.string :tags

      t.timestamps null: false
    end
  end
end
