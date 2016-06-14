class SetContestRulesDefault < ActiveRecord::Migration
	def change
		change_column :contests, :rule, :text,
			default: File.open('app/assets/default_rules.txt', 'r').read
	end
end
