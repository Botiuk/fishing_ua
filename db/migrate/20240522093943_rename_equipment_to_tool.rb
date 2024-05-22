class RenameEquipmentToTool < ActiveRecord::Migration[7.1]
  def change
    rename_table :equipment, :tools
  end
end
