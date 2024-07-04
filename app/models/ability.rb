# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    
    can :read, :main
    can :read, WaterBioresource
    can :read, CatchRate
    can :read, RatePenalty
    can :read, DayRate
    can :read, NewsStory

    if user.present?      
      can [:read, :create, :update, :statistic], FishingPlace, user_id: user.id
      can :manage, Tool, user_id: user.id
      can [:read, :create, :update], FishingSession, user_id: user.id      
      can [:read, :create, :update], Catch do |catch|
        catch.user.id == user.id
      end
      can [:create, :destroy], ToolCatch do |tool_catch|
        tool_catch.tool.user.id == user.id
      end
      can :statistic, WaterBioresource
      can :statistic, :main

      if user.role == "staff"
        can [:create, :update, :destroy], NewsStory, user_id: user.id
      end

      if user.role == "admin"
        can [:create, :update], WaterBioresource        
        can :manage, CatchRate
        can :manage, RatePenalty
        can :manage, DayRate
        can :manage, NewsStory
        can [:read, :update, :search], User
      end
    end

  end
end
