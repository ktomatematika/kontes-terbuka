class CreateUserReferrers < ActiveRecord::Migration
  def change
    create_table :user_referrers do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
