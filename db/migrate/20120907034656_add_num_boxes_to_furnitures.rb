class AddNumBoxesToFurnitures < ActiveRecord::Migration
  def change
    add_column :furnitures, :num_boxes, :integer
  end
end
