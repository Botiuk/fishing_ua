class Tool < ApplicationRecord
  belongs_to :user
  has_many :tool_catches, dependent: :destroy
  has_many :catches, through: :tool_catches

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: [:user_id, :tool_type] }
  validates :tool_type, presence: true

  enum :tool_type, { equipment: 0, bait: 1 }, prefix: true

  private

  def self.statistic_all_tool_type_records(user_id, search_type, search_params, tool_type)
    case search_type
    when "water_bioresource"
      Tool.joins(:catches).where(catches: {water_bioresource_id: search_params}).where(user_id: user_id, tool_type: tool_type).group(:name).count
    when "fishing_place"
      catches_ids = Catch.joins(:fishing_place).where(fishing_place: {id: search_params,}).pluck(:id)
      Tool.joins(:catches).where(catches: {id: catches_ids}).where(tool_type: tool_type).group(:name).count
    end
  end
end
