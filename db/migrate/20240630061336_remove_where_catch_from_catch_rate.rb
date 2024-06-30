class RemoveWhereCatchFromCatchRate < ActiveRecord::Migration[7.1]
  def change
    remove_column :catch_rates, :where_catch, :integer
  end
end
