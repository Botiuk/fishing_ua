# frozen_string_literal: true

class Tool < ApplicationRecord
  belongs_to :user
  has_many :tool_catches, dependent: :destroy
  has_many :catches, through: :tool_catches

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: %i[user_id tool_type] }
  validates :tool_type, presence: true

  enum :tool_type, { equipment: 0, bait: 1 }, prefix: true

  def self.statistic_all_tool_type_records(user_id, search_type, search_params, tool_type)
    case search_type
    when 'water_bioresource'
      Tool.joins(:catches).where(catches: { water_bioresource_id: search_params })
          .where(user_id: user_id, tool_type: tool_type).order(:name).group(:name).count
    when 'fishing_place'
      catches_ids = Catch.joins(:fishing_place).where(fishing_place: { id: search_params }).pluck(:id)
      Tool.joins(:catches).where(catches: { id: catches_ids }).where(tool_type: tool_type)
          .order(:name).group(:name).count
    when 'tool'
      catches_ids = Catch.joins(:tools).where(tools: { id: search_params }).pluck(:id)
      Tool.joins(:catches).where(catches: { id: catches_ids }).where(tool_type: tool_type)
          .where.not(id: search_params).order(:name).group(:name).count
    when 'fishing_session'
      Tool.joins(:catches).where(catches: { fishing_session_id: search_params }).where(tool_type: tool_type)
          .order(:name).group(:name).count
    when 'user'
      catches_ids = Catch.joins(:fishing_place).where(fishing_place: { user_id: user_id }).pluck(:id)
      Tool.joins(:catches).where(catches: { id: catches_ids }).where(tool_type: tool_type)
          .order(:name).group(:name).count
    end
  end
end
