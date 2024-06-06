class DayRate < ApplicationRecord
  belongs_to :water_bioresource

  validates :catch_amount, :amount_type, presence: true
  validates :water_bioresource_id, uniqueness: true
  validates_with DayRateValidator

  enum :amount_type, { weight: 0, quantity: 1 }, prefix: true
end