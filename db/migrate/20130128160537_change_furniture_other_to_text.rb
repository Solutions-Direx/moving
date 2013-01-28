class ChangeFurnitureOtherToText < ActiveRecord::Migration
  def change
  	change_column :furnitures, :furniture_other, :text
  end
end