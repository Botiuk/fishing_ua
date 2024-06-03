class CreateCatches < ActiveRecord::Migration[7.1]
  def change
    create_table :catches do |t|
      t.datetime :catch_time
      t.decimal :catch_length, precision: 4, scale: 1, default: 0.0
      t.decimal :catch_weight, precision: 5, scale: 3, default: 0.000
      t.integer :catch_result
      t.references :fishing_session, null: false, foreign_key: true
      t.references :water_bioresource, null: false, foreign_key: true

      t.timestamps
    end
  end
end
