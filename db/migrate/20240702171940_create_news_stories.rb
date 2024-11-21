# frozen_string_literal: true

class CreateNewsStories < ActiveRecord::Migration[7.1]
  def change
    create_table :news_stories do |t|
      t.string :title, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
