class Ability
  include CanCan::Ability

  # rubocop:disable AbcSize, MethodLength, CyclomaticComplexity
  def initialize(user)
    return if user.nil?

    # Contest related
    can [:show, :index], Contest
    can :download_results, Contest, result_released: true
    can [:show_rules, :accept_rules], Contest,
        id: Contest.where('start_time <= ? AND ? <= end_time',
                          Time.zone.now, Time.zone.now).pluck(:id)
    can [:download_pdf, :give_feedback, :feedback_submit], Contest,
        id: UserContest.where(user: user).pluck(:contest_id)
    can [:submit, :destroy_submissions, :download], LongSubmission,
        user_contest_id: user.user_contests.pluck(:id)
    can :create_on_contest, ShortSubmission
    can [:new, :create, :stop_nag], UserContest, user: user
    can [:new_on_contest, :create_on_contest], FeedbackAnswer
    can [:edit_on_user, :flip], UserNotification

    # User related
    can :show, User, enabled: true
    can :index, User
    can [:see_full, :mini_edit, :mini_update, :change_password,
         :process_change_password, :change_notifications,
         :process_change_notifications], User, id: user.id

    if user.has_role? :marking_manager
      can [:mark_final, :start_mark_final, :download], LongProblem
      can [:assign_markers, :create_marker, :remove_marker], Role
    end

    if user.has_role? :marker, :any
      can [:download, :submit_temporary_markings, :autofill, :upload_report],
          LongProblem, id: LongProblem.with_role(:marker, user).pluck(:id)
      can :download_marking_scheme, Contest,
          id: LongProblem.with_role(:marker, user).pluck(:contest_id)
      can :admin, Application
    end

    if user.has_role? :panitia
      can [:preview, :summary, :view_all, :admin], Contest
      can [:see_full_index, :see_full], User
      can :download_on_contest, FeedbackAnswer
      can [:admin, :profile], Application
    end

    can [:edit, :update, :destroy], User if user.has_role? :user_admin

    if user.has_role? :problem_admin
      can [:admin, :read_problems, :destroy_short_probs,
           :destroy_long_probs, :upload_ms], Contest
      can :manage, ShortProblem
      can [:create, :edit, :update, :destroy, :destroy_on_contest], LongProblem
    end

    can :manage, :all if user.has_role? :admin
  end
end
