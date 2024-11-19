# frozen_string_literal: true

class CreateRatePenalties < ActiveRecord::Migration[7.1]
  def change
    create_table :rate_penalties do |t|
      t.references :water_bioresource, null: false, foreign_key: true
      t.integer :money

      t.timestamps
    end
  end
end
