class CreateUserAwards < ActiveRecord::Migration
  def change
    create_table :user_awards do |t|
      t.integer :user_id
      t.integer :award_id
      t.timestamps null: false
    end
  end
end
