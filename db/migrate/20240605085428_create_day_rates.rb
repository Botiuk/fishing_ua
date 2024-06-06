class CreateDayRates < ActiveRecord::Migration[7.1]
  def change
    create_table :day_rates do |t|
      t.decimal :catch_amount, precision: 3, scale: 1, default: 0.0
      t.integer :amount_type
      t.references :water_bioresource, null: false, foreign_key: true

      t.timestamps
    end
  end
end
