# frozen_string_literal: true

class AddResourceTypeToWaterBioresources < ActiveRecord::Migration[7.1]
  change_table :water_bioresources do |t|
    t.integer :resource_type
  end
  change_column_null :water_bioresources, :resource_type, false
end
