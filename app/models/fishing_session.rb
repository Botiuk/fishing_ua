class FishingSession < ApplicationRecord
  belongs_to :user
  belongs_to :fishing_place
  has_many :catches

  validates :start_at, presence: true
  validates :end_at, comparison: { greater_than: :start_at }, allow_blank: true
end
