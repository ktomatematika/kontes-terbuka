class Ability
  include CanCan::Ability

  # rubocop:disable AbcSize, MethodLength
  def initialize(user)
    unless user.nil?
      can [:show, :index, :show_rules,
           :accept_rules, :create_short_submissions], Contest
      can [:download_pdf, :give_feedback, :feedback_submit], Contest,
          id: UserContest.where(user: user).pluck(:contest_id)

      can :download, SubmissionPage, id: user.submission_pages.pluck(:id)
      can [:show, :index], User
      can :submit, LongProblem
      can [:see_full, :mini_edit, :mini_update, :change_password,
           :process_change_password, :change_notifications,
           :process_change_notifications], User, id: user.id

      if user.has_role? :marking_manager
        can [:assign_markers, :save_markers], Contest
        can :mark_final, LongProblem
        can [:create_marker, :remove_marker], Role
      end

      can [:mark_solo, :mark_final, :download], LongProblem,
          id: LongProblem.with_role(:marker, user).pluck(:id)

      if user.has_role? :panitia
        can :preview, Contest
        can [:see_full_index, :see_full, :edit, :update], User
        can [:admin, :profile], Ability
      end

      can :manage, :all if user.has_role? :admin
    end
  end
end
