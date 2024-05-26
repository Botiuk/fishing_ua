class AddToolTypeToTools < ActiveRecord::Migration[7.1]
  def change
    add_column :tools, :tool_type, :integer
  end
end
