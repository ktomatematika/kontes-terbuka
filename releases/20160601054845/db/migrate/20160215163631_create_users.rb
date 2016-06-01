class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password
      t.string :fullname
      t.string :school
      t.integer :point
      t.timestamps null: false
    end
  end
end
