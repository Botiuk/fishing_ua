# frozen_string_literal: true

class CreateDayRates < ActiveRecord::Migration[7.1]
  def change
    create_table :day_rates do |t|
      t.decimal :catch_amount, precision: 3, scale: 1, default: 0.0
      t.integer :amount_type, null: false
      t.references :water_bioresource, null: false, foreign_key: true, index: { unique: true }

      t.timestamps
    end
  end
end
