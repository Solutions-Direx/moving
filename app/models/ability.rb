class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :quick_view, :to => :read
    
    user ||= User.new # guest user (not logged in)
    if user.manager?
      can :manage, :all
    elsif user.standard?
      can :read, :dashboard
      can :manage, Document
      can :manage, Storage
      can :manage, Client
      can :manage, Supply
      can :manage, Quote
      can :manage, Truck
      can :manage, Forfait
      can :manage, Furniture
    elsif user.removal_man?
      can :read, :dashboard
      can :read, Document
      can :read, Storage
      can :read, Client
      can :read, Supply
      can :read, Quote
      can :read, Truck
      can :read, Forfait
      can :read, Furniture
    end
  end
end
