class AddContestRefToLongSubmissions < ActiveRecord::Migration
  def change
    add_reference :long_submissions, :contest, index: true, foreign_key: true
  end
end
