class EnforceValidationsInDatabaseLevel < ActiveRecord::Migration
  def change
    validates :colors, :name, uniqueness: true, presence: true

    validates :contests, :name, presence: true
    remove_column :contests, :type
    validates :contests, :number_of_short_questions, null: false
    validates :contests, :number_of_long_questions, null: false
    validates :contests, :start_time, null: false
    validates :contests, :end_time, null: false
    validates :contests, :result_time, null: false
    change_column :contests, :rule, :text, null: false
    validates :contests, :feedback_time, null: false

    validates :long_problems, :contest_id, null: false
    validates :long_problems, :problem_no, null: false

    validates :long_submissions, :user_id, null: false
    validates :long_submissions, :long_problem_id, null: false
    validates :long_submissions, :page, null: false

    validates :provinces, :name, presence: true, uniqueness: true

    validates :short_problems, :contest_id, null: false
    validates :short_problems, :problem_no, null: false
    validates :short_problems, :answer, presence: true

    validates :short_submissions, :user_id, null: false
    validates :short_submissions, :short_problem_id, null: false
    validates :short_submissions, :answer, presence: true

    validates :user_contests, :user_id, null: false
    validates :user_contests, :contest_id, null: false

    validates :users, :username, presence: true, uniqueness: true,
                                 length: { in: 6..20 }, format: { with: /\A[A-Za-z0-9]+\Z/ }
    validates :users, :email, presence: true, uniqueness: true,
                              format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }
    validates :users, :hashed_password, presence: true
    validates :users, :fullname, presence: true
    validates :users, :school, presence: true
    validates :users, :point, null: false
    validates :users, :salt, presence: true
    validates :users, :auth_token, presence: true
    validates :users, :province_id, null: false
    validates :users, :status_id, null: false

    validates :users_roles, :user_id, null: false
    validates :users_roles, :role_id, null: false
  end
end
