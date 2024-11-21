# frozen_string_literal: true

class CreateWaterBioresources < ActiveRecord::Migration[7.1]
  def change
    create_table :water_bioresources do |t|
      t.string :name, null: false
      t.string :latin_name, null: false

      t.timestamps
    end
    add_index :water_bioresources, 'lower(name)', unique: true
    add_index :water_bioresources, 'lower(latin_name)', unique: true
  end
end
