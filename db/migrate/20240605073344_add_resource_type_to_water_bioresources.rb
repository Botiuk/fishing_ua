class AddResourceTypeToWaterBioresources < ActiveRecord::Migration[7.1]
  def change
    add_column :water_bioresources, :resource_type, :integer
  end
end
