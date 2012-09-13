class RenameLivingOtherFromFurnituresToFurnitureOther < ActiveRecord::Migration
  def change
    rename_column :furnitures, :living_other, :furniture_other
    remove_column :furnitures, :base_other
    remove_column :furnitures, :outside_other
  end
end
