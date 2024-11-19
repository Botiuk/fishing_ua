# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can %i[read about], :main
    can :read, WaterBioresource
    can :read, CatchRate
    can :read, RatePenalty
    can :read, DayRate
    can :read, NewsStory do |news_story|
      !news_story.published_at.nil? && news_story.published_at <= DateTime.now
    end

    return if user.blank?

    can %i[read create update statistic], FishingPlace, user_id: user.id
    can :manage, Tool, user_id: user.id
    can %i[read create update], FishingSession, user_id: user.id
    can :manage, Catch do |catch|
      catch.user.id == user.id
    end
    can [:create, :destroy], ToolCatch do |tool_catch|
      tool_catch.tool.user.id == user.id
    end
    can :statistic, WaterBioresource
    can :statistic, :main

    if user.role == 'staff'
      can %i[create update destroy], NewsStory, user_id: user.id
      can :read, NewsStory
    end

    return unless user.role == 'admin'

    can %i[create update], WaterBioresource
    can :manage, CatchRate
    can :manage, RatePenalty
    can :manage, DayRate
    can :manage, NewsStory
    can %i[read update search], User
  end
end
