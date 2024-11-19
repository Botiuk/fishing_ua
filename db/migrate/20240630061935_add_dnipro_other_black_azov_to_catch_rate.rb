# frozen_string_literal: true

class AddDniproOtherBlackAzovToCatchRate < ActiveRecord::Migration[7.1]
  def change
    change_table :catch_rates, bulk: true do |t|
      t.decimal :length_dnipro, precision: 3, scale: 1
      t.decimal :length_other, precision: 3, scale: 1
      t.decimal :length_black, precision: 3, scale: 1
      t.decimal :length_azov, precision: 3, scale: 1
    end
  end
end
