class Ability
  include CanCan::Ability

  # rubocop:disable AbcSize, MethodLength
  def initialize(user)
    unless user.nil?
      can [:show, :index, :show_rules,
           :accept_rules, :create_short_submissions], Contest
      can [:show_rules, :accept_rules], Contest,
          id: Contest.where('start_time <= ? AND ? <= end_time',
                            Time.zone.now, Time.zone.now).pluck(:id)
      can [:download_pdf, :give_feedback, :feedback_submit], Contest,
          id: UserContest.where(user: user).pluck(:contest_id)
      can [:submit, :destroy_submissions, :download], LongSubmission,
          id: user.long_submissions.pluck(:id)

      can :show, User, id: User.where(enabled: true).pluck(:id)
      can :index, User
      can [:see_full, :mini_edit, :mini_update, :change_password,
           :process_change_password, :change_notifications,
           :process_change_notifications], User, id: user.id

      if user.has_role? :marking_manager
        can [:assign_markers, :save_markers], Contest
        can :mark_final, LongProblem
        can [:create_marker, :remove_marker], Role
      end

      can [:mark_solo, :mark_final, :download, :submit_temporary_markings,
           :submit_final_markings, :autofill, :upload_report], LongProblem,
          id: LongProblem.with_role(:marker, user).pluck(:id)

      if user.has_role? :panitia
        can [:preview, :summary, :download_marking_scheme], Contest
        can [:see_full_index, :see_full, :edit, :update], User
        can :destroy, User, id: User.where(enabled: false).pluck(:id)
        can [:admin, :profile], Ability
      end

      can :manage, :all if user.has_role? :admin
    end
  end
end
