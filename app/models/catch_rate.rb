class CatchRate < ApplicationRecord
  belongs_to :water_bioresource

  validates :water_bioresource, uniqueness: true
  validates :length_dnipro, :length_other, :length_black, :length_azov, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :ordered, -> { joins(:water_bioresource).order('water_bioresources.name') }

  # def self.rate_length(water_bioresource_id, where_catch)
  #   CatchRate.where(water_bioresource_id: water_bioresource_id, where_catch: where_catch).first
  # end
end
