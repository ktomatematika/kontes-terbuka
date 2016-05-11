class HomeController < ApplicationController
	http_basic_authenticate_with name: "admin", password: "admin", only: :admin
	def index
		now = Time.now
		@next_contest = nil
		Contest.all.each do |contest|
			if (contest.start_time > now ||
				(contest.start_time <= now && contest.end_time > now)) &&
				(@next_contest == nil ||
				 contest.start_time < @next_contest.start_time)
				@next_contest = contest
			end
		end
	end

	def admin
	end
end
