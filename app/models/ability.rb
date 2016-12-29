class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?
    user_abilities(user)

    %w(marker panitia marking_manager user_admin problem_admin).each do |role|
      send("#{role}_abilities", user) if user.has_role? role, :any
    end

    can :manage, :all if user.has_role? :admin
  end

  private

  def user_abilities(user)
    contest_related_user_abilities(user)
    user_related_user_abilities(user)
  end

  def contest_related_user_abilities(user)
    can [:show, :index], Contest
    can :download_results, Contest, result_released: true
    can [:show_rules, :accept_rules], Contest,
        id: Contest.currently_in_contest.pluck(:id)
    can [:download_problem_pdf, :give_feedback, :feedback_submit], Contest,
        id: user.user_contests.pluck(:contest_id)
    can [:submit, :destroy, :download], LongSubmission,
        user_contest_id: user.user_contests.pluck(:id)
    can :create_on_contest, ShortSubmission
    can [:new, :create], UserContest, user: user
    can [:new_on_contest, :create_on_contest], FeedbackAnswer
  end

  def user_related_user_abilities(user)
    can :show, User, enabled: true
    can :index, User
    can [:show_full, :mini_edit, :mini_update, :change_password,
         :process_change_password, :referrer_update], User, id: user.id
    can [:edit_on_user, :flip], UserNotification
  end

  def marker_abilities(user)
    long_problems = LongProblem.with_role(:marker, user)
    can [:download_submissions, :autofill, :upload_report, :mark],
        LongProblem, id: long_problems.pluck(:id)
    can [:mark, :submit_mark], LongSubmission,
        long_problem_id: long_problems.pluck(:id)
    can :download_marking_scheme, Contest, id: long_problems.pluck(:contest_id)
    can :admin, Application
  end

  def panitia_abilities(_user)
    can [:preview, :summary, :admin, :download_marking_scheme,
         :download_problem_pdf, :download_reports], Contest
    can [:index_full, :show_full, :show], User
    can :download_on_contest, FeedbackAnswer
    can [:admin, :profile, :see_referrers], Application
  end

  def marking_manager_abilities(_user)
    can [:start_mark_final, :download_submissions], LongProblem
    can [:assign_markers, :create_marker, :remove_marker], Role
  end

  def user_admin_abilities(_user)
    can [:edit, :update, :destroy, :mini_edit, :mini_update], User
  end

  def problem_admin_abilities(_user)
    can [:admin, :read_problems, :destroy_short_probs,
         :destroy_long_probs, :upload_ms], Contest
    can :manage, ShortProblem
    can [:create, :edit, :update, :destroy, :destroy_on_contest], LongProblem
  end
end
