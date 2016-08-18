class UserContestsController < ApplicationController
  load_and_authorize_resource

  def stop_nag
    @user_contest.update(donation_nag: false)
    head 200
  end
end
