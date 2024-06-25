class ToolCatch < ApplicationRecord
  belongs_to :tool
  belongs_to :catch

  validates :tool_id, uniqueness: { scope: :catch_id }

  scope :order_by_tool, -> { joins(:tool).order('tools.tool_type, tools.name') }
end
