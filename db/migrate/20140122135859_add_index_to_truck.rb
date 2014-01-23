class AddIndexToTruck < ActiveRecord::Migration
  def change
    add_index :trucks, :name, :name => "trucks_name_index"
  end
end
