# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    
    can :read, :main
    can :read, CatchRate

    if user.present?
      can [:read, :create, :update], FishingPlace, user_id: user.id
      can :manage, Tool, user_id: user.id
    #   can :manage, FishingSession, user_id: user.id

    #   if user.staff?
    #     can [:read, :create, :update], News
    #   end

      if user.role == "admin"
        can [:read, :create, :update], WaterBioresource
        can :manage, RatePenalty
        can :manage, CatchRate
        # can :manage, News
      end
    end

  end
end
