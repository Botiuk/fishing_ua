# frozen_string_literal: true

class CreateToolCatches < ActiveRecord::Migration[7.1]
  def change
    create_table :tool_catches do |t|
      t.references :tool, null: false, foreign_key: true
      t.references :catch, null: false, foreign_key: true

      t.timestamps
    end
  end
end
