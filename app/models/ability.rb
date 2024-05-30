# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    
    can :read, :main
    can :read, WaterBioresource
    can :read, CatchRate
    can :read, RatePenalty

    if user.present?
      can [:read, :create, :update], FishingPlace, user_id: user.id
      can :manage, Tool, user_id: user.id
      can [:read, :create, :update], FishingSession, user_id: user.id

    #   if user.staff?
    #     can [:read, :create, :update], News
    #   end

      if user.role == "admin"
        can [:create, :update], WaterBioresource        
        can :manage, CatchRate
        can :manage, RatePenalty
        # can :manage, News
      end
    end

  end
end
