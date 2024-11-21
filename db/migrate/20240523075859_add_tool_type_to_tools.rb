# frozen_string_literal: true

class AddToolTypeToTools < ActiveRecord::Migration[7.1]
  def change
    change_table :tools do |t|
      t.integer :tool_type
    end
    change_column_null :tools, :tool_type, false
    add_index :tools, 'lower(name), "user_id", "tool_type"', unique: true
  end
end
