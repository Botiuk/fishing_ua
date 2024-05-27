class FishingPlace < ApplicationRecord
  belongs_to :user
  has_many :fishing_sessions

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :user_id }
  validates :where_catch, presence: true

  enum :where_catch, { dnipro: 0, other: 1, black: 2, azov: 3 }, prefix: true
end
