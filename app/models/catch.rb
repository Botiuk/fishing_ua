class Catch < ApplicationRecord
  belongs_to :fishing_session
  belongs_to :water_bioresource
  has_one :fishing_place, through: :fishing_session
  has_one :user, through: :fishing_session

  has_many_attached :catch_photos  

  validates :catch_time, :catch_length, :catch_weight, :catch_result, presence: true

  enum :catch_result, { set_free: 0, pick_up: 1 }, prefix: true

  private

  def self.all_day_catch_weight(fishing_session_id, day_rate_water_bioresource_ids)    
    Catch.where(fishing_session_id: fishing_session_id, catch_result: "pick_up", catch_time: DateTime.now.beginning_of_day..DateTime.now.end_of_day).where.not(water_bioresource_id: day_rate_water_bioresource_ids).sum(:catch_weight).to_s.to_f
  end

  def self.maximum_day_catch(fishing_session_id, day_rate_water_bioresource_ids)
    Catch.where(fishing_session_id: fishing_session_id, catch_result: "pick_up", catch_time: DateTime.now.beginning_of_day..DateTime.now.end_of_day).where.not(water_bioresource_id: day_rate_water_bioresource_ids).maximum(:catch_weight).to_s.to_f
  end

  def self.all_day_catch_one_resource_weight(fishing_session_id, water_bioresource_id)
    Catch.where(fishing_session_id: fishing_session_id, catch_result: "pick_up", catch_time: DateTime.now.beginning_of_day..DateTime.now.end_of_day, water_bioresource_id: water_bioresource_id).sum(:catch_weight).to_s.to_f
  end

  def self.all_day_catch_one_resource_quantity(fishing_session_id, water_bioresource_id)
    Catch.where(fishing_session_id: fishing_session_id, catch_result: "pick_up", catch_time: DateTime.now.beginning_of_day..DateTime.now.end_of_day, water_bioresource_id: water_bioresource_id).count
  end

end
