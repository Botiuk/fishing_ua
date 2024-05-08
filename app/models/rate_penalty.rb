class RatePenalty < ApplicationRecord
  belongs_to :water_bioresource

  validates :money, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
