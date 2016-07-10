class AddTransactionHistory < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :point
      t.string :description
      t.integer :user_id
      t.timestamps null: false
    end
    validates :transactions, :point, null: false
    validates :transactions, :description, presence: true
    remove_column :users, :point
  end
end
