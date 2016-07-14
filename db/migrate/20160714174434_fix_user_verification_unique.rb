class FixUserVerificationUnique < ActiveRecord::Migration
  def change
    validates :users, :verification, uniqueness: { allow_nil: true }
  end
end
