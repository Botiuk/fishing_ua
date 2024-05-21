class CreateFishingPlaces < ActiveRecord::Migration[7.1]
  def change
    create_table :fishing_places do |t|
      t.string :name
      t.string :description
      t.integer :where_catch
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
