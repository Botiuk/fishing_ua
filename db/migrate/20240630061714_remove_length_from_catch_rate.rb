# frozen_string_literal: true

class RemoveLengthFromCatchRate < ActiveRecord::Migration[7.1]
  def change
    remove_column :catch_rates, :length, :decimal
  end
end
