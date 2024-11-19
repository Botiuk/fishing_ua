# frozen_string_literal: true

class CreateWaterBioresources < ActiveRecord::Migration[7.1]
  def change
    create_table :water_bioresources do |t|
      t.string :name
      t.string :latin_name

      t.timestamps
    end
  end
end
