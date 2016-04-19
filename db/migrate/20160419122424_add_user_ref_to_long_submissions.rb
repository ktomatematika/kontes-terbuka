class AddUserRefToLongSubmissions < ActiveRecord::Migration
  def change
    add_reference :long_submissions, :user, index: true, foreign_key: true
  end
end
