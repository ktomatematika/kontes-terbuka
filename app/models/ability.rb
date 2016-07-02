class Ability
  include CanCan::Ability

  def initialize(user)
    unless user.nil?
      can [:show, :index, :show_rules, :accept_rules], Contest
      can :manage, User, id: user.id
      can :show, User
      cannot :index, User
      can :submit, LongProblem

      can [:mark_solo, :mark_final], LongProblem,
          id: LongProblem.with_role(:marker, user).pluck(:id)

      can :manage, :all if user.has_role? :admin
    end
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
