class Ability
  include CanCan::Ability

  # rubocop:disable AbcSize, MethodLength
  def initialize(user)
    unless user.nil?
      can [:show, :index, :show_rules,
           :accept_rules, :create_short_submissions], Contest
      can :download_results, Contest, result_released: true
      can [:show_rules, :accept_rules], Contest,
          id: Contest.where('start_time <= ? AND ? <= end_time',
                            Time.zone.now, Time.zone.now).pluck(:id)
      can [:download_pdf, :give_feedback, :feedback_submit], Contest,
          user_contest: UserContest.where(user: user)
      can [:submit, :destroy_submissions, :download], LongSubmission,
          user: user

      can :show, User, enabled: true
      can :index, User
      can [:see_full, :mini_edit, :mini_update, :change_password,
           :process_change_password, :change_notifications,
           :process_change_notifications], User, id: user.id

      can :stop_nag, UserContest, user: user

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
        can [:preview, :summary], Contest
        can [:see_full_index, :see_full], User
        can :destroy, User, enabled: false
        can [:admin, :profile], Application
      end

      can :manage, :all if user.has_role? :admin
    end
  end
end
