class ToolCatch < ApplicationRecord
  belongs_to :tool
  belongs_to :catch

  validates :tool_id, uniqueness: { scope: :catch_id }
end
