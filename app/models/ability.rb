class Ability
  include CanCan::Ability

  # rubocop:disable AbcSize, MethodLength, CyclomaticComplexity
  def initialize(user)
    return if user.nil?

    # Contest related
    can [:show, :index, :show_rules,
         :accept_rules, :create_short_submissions], Contest
    can :download_results, Contest, result_released: true
    can [:show_rules, :accept_rules], Contest,
        id: Contest.where('start_time <= ? AND ? <= end_time',
                          Time.zone.now, Time.zone.now).pluck(:id)
    can [:download_pdf, :give_feedback, :feedback_submit], Contest,
        id: UserContest.where(user: user).pluck(:contest_id)
    can [:submit, :destroy_submissions, :download], LongSubmission,
        user_contest_id: user.user_contests.pluck(:id)
    can :stop_nag, UserContest, user: user

    # User related
    can :show, User, enabled: true
    can :index, User
    can [:see_full, :mini_edit, :mini_update, :change_password,
         :process_change_password, :change_notifications,
         :process_change_notifications], User, id: user.id

    if user.has_role? :marking_manager
      can [:assign_markers, :save_markers], Contest
      can :mark_final, LongProblem
      can [:create_marker, :remove_marker], Role
    end

    if user.has_role? :marker, :any
      can [:mark_solo, :mark_final, :download, :submit_temporary_markings,
           :submit_final_markings, :autofill, :upload_report], LongProblem,
          id: LongProblem.with_role(:marker, user).pluck(:id)
      can :download_marking_scheme, Contest,
          id: LongProblem.with_role(:marker, user).pluck(:contest_id)
      can :admin, Application
    end

    if user.has_role? :panitia
      can [:preview, :summary, :view_all], Contest
      can [:see_full_index, :see_full], User
      can [:admin, :profile], Application
      can [:download_pdf, :download_marking_scheme, :download_reports], Contest
    end

    can [:edit, :update, :destroy], User if user.has_role? :user_admin

    if user.has_role? :problem_admin
      can [:admin, :read_problems, :destroy_short_probs,
           :destroy_long_probs, :upload_ms], Contest
      can :manage, ShortProblem
      can :manage, LongProblem
    end

    can :manage, :all if user.has_role? :admin
  end
end
