class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :quick_view, :terms, :to => :read
    
    user ||= User.new # guest user (not logged in)
    if user.manager?
      can :manage, :all
    elsif user.standard?
      can :read, :dashboard
      can :manage, Client
      can :manage, Document
      can :manage, Forfait
      can :manage, Furniture
      can :manage, Quote
      can :manage, Storage
      can :manage, Supply
      can :manage, Truck
      can :manage, Invoice
      can :manage, Report
      can :sign, Quote
    elsif user.removal_man?
      can :read, :dashboard
      can :read, Client
      can :read, Document
      can :read, Forfait
      can :read, Furniture
      can :read, Quote
      can :read, Storage
      can :read, Supply
      can :read, Truck
      can [:read, :edit, :new], Invoice
      can [:read, :edit, :new], Report
      can :sign, Quote
    end
  end
end