# frozen_string_literal: true

class CreateFishingSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :fishing_sessions do |t|
      t.datetime :start_at, null: false
      t.datetime :end_at
      t.references :user, null: false, foreign_key: true
      t.references :fishing_place, null: false, foreign_key: true

      t.timestamps
    end
  end
end
