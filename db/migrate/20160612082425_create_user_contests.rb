class CreateUserContests < ActiveRecord::Migration
  def change
    create_table :user_contests do |t|
      t.references :user, index: true, foreign_key: true
      t.references :contest, index: true, foreign_key: true
      t.boolean :confirm_participation
      t.timestamps null: false
    end
  end
end
