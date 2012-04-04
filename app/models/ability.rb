class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.manager?
      can :manage, :all
    elsif user.standard?
      can :read, :dashboard
      can :manage, Document
    elsif user.removal_man?
      can :read, :dashboard
      can :read, Document
    end
  end
end
