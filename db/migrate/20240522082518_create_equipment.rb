# frozen_string_literal: true

class CreateEquipment < ActiveRecord::Migration[7.1]
  def change
    create_table :equipment do |t|
      t.string :name, null: false
      t.string :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
