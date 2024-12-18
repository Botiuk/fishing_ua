# frozen_string_literal: true

class FishingPlace < ApplicationRecord
  belongs_to :user
  has_many :fishing_sessions, dependent: nil
  has_many :catches, through: :fishing_sessions

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :user_id }
  validates :where_catch, presence: true

  enum :where_catch, { dnipro: 0, other: 1, black: 2, azov: 3 }, prefix: true

  def self.statistic_all_records(user_id, search_type, search_params)
    case search_type
    when 'water_bioresource'
      FishingPlace.joins(:catches).where(catches: { water_bioresource_id: search_params })
                  .where(user_id: user_id).order(:name).group(:name).count
    when 'tool'
      catches_ids = Catch.joins(:tools).where(tools: { id: search_params }).pluck(:id)
      FishingPlace.joins(:catches).where(catches: { id: catches_ids }).order(:name).group(:name).count
    when 'user'
      catches_ids = Catch.joins(:fishing_place).where(fishing_place: { user_id: user_id }).pluck(:id)
      FishingPlace.joins(:catches).where(catches: { id: catches_ids }).order(:name).group(:name).count
    end
  end
end
