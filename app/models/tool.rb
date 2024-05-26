class Tool < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: [:user_id, :tool_type] }
  validates :tool_type, presence: true

  enum :tool_type, { equipment: 0, bait: 1 }, prefix: true
end
