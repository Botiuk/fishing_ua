# frozen_string_literal: true

class WaterBioresource < ApplicationRecord
  has_one :rate_penalty, dependent: nil
  has_one :day_rate, dependent: nil
  has_one :catch_rate, dependent: nil
  has_many :catches, dependent: nil

  has_one_attached :bioresource_photo
  has_rich_text :bioresource_description

  validates :name, :latin_name, presence: true, uniqueness: { case_sensitive: false }
  validates :resource_type, presence: true

  enum :resource_type, { small_fish: 0, other_fish: 1, invertebrate: 2 }, prefix: true

  validates_each :name, :latin_name do |record, attr, value|
    record.errors.add(attr, I18n.t('errors.messages.first_letter')) if /\A[[:lower:]]/.match?(value)
  end

  def self.statistic_all_records(user_id, search_type, search_params)
    case search_type
    when 'fishing_place'
      catches_ids = Catch.joins(:fishing_place).where(fishing_place: { id: search_params }).pluck(:id)
      WaterBioresource.joins(:catches).where(catches: { id: catches_ids }).order(:name).group(:name).count
    when 'tool'
      catches_ids = Catch.joins(:tools).where(tools: { id: search_params }).pluck(:id)
      WaterBioresource.joins(:catches).where(catches: { id: catches_ids }).order(:name).group(:name).count
    when 'fishing_session'
      WaterBioresource.joins(:catches).where(catches: { fishing_session_id: search_params })
                      .order(:name).group(:name).count
    when 'user'
      catches_ids = Catch.joins(:fishing_place).where(fishing_place: { user_id: user_id }).pluck(:id)
      WaterBioresource.joins(:catches).where(catches: { id: catches_ids }).order(:name).group(:name).count
    end
  end
end
