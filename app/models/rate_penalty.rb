# frozen_string_literal: true

class RatePenalty < ApplicationRecord
  belongs_to :water_bioresource

  validates :money, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :water_bioresource_id, uniqueness: true
end
