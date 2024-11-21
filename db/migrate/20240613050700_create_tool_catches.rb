# frozen_string_literal: true

class CreateToolCatches < ActiveRecord::Migration[7.1]
  def change
    create_table :tool_catches do |t|
      t.references :tool, null: false, foreign_key: true
      t.references :catch, null: false, foreign_key: true

      t.timestamps
    end
    add_index :tool_catches, %i[tool_id catch_id], unique: true
  end
end
