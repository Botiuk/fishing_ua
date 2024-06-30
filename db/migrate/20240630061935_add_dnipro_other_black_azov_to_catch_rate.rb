class AddDniproOtherBlackAzovToCatchRate < ActiveRecord::Migration[7.1]
  def change
    add_column :catch_rates, :length_dnipro, :decimal, precision: 3, scale: 1
    add_column :catch_rates, :length_other, :decimal, precision: 3, scale: 1
    add_column :catch_rates, :length_black, :decimal, precision: 3, scale: 1
    add_column :catch_rates, :length_azov, :decimal, precision: 3, scale: 1
  end
end
