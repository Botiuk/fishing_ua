class Catch < ApplicationRecord
  belongs_to :fishing_session
  belongs_to :water_bioresource
  has_one :fishing_place, through: :fishing_session
  has_one :user, through: :fishing_session

  has_many_attached :catch_photos  

  validates :catch_time, :catch_length, :catch_weight, :catch_result, presence: true

  enum :catch_result, { set_free: 0, pick_up: 1 }, prefix: true
end
