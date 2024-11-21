# frozen_string_literal: true

class CreateFishingPlaces < ActiveRecord::Migration[7.1]
  def change
    create_table :fishing_places do |t|
      t.string :name, null: false
      t.string :description
      t.integer :where_catch, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :fishing_places, 'lower(name), "user_id"', unique: true
  end
end
