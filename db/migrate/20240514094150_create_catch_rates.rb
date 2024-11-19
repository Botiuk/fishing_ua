# frozen_string_literal: true

class CreateCatchRates < ActiveRecord::Migration[7.1]
  def change
    create_table :catch_rates do |t|
      t.references :water_bioresource, null: false, foreign_key: true
      t.integer :where_catch
      t.decimal :length, precision: 3, scale: 1, default: 0.0

      t.timestamps
    end
  end
end
