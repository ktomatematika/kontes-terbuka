class AddStatusRefToUsers < ActiveRecord::Migration
	def change
		add_reference :users, :status, index: true, foreign_key: true
	end
end
