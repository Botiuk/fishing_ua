class FishingPlace < ApplicationRecord
  belongs_to :user
  has_many :fishing_sessions
  has_many :catches, through: :fishing_sessions

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :user_id }
  validates :where_catch, presence: true

  enum :where_catch, { dnipro: 0, other: 1, black: 2, azov: 3 }, prefix: true

  private

  def self.statistic_all_records(user_id, search_type, search_params)
    case search_type
    when "water_bioresource"
      FishingPlace.joins(:catches).where(catches: {water_bioresource_id: search_params}).where(user_id: user_id).group(:name).count
    end    
  end
end
