class CatchRate < ApplicationRecord
  belongs_to :water_bioresource

  validates :water_bioresource_id, presence: true, uniqueness: { scope: :where_catch }
  validates :length, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :where_catch, presence: true

  enum :where_catch, { dnipro: 0, other: 1, black: 2, azov: 3 }, prefix: true
end
