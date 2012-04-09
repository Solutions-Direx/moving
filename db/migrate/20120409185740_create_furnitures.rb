class CreateFurnitures < ActiveRecord::Migration
  def change
    create_table :furnitures do |t|
      t.integer :num_appliances
      t.integer :kitchen_table
      t.integer :kitchen_chair
      t.integer :kitchen_buffet
      t.integer :living_couch_3pl
      t.integer :living_couch_2pl
      t.integer :living_armchair
      t.integer :living_table
      t.integer :living_wall_unit
      t.integer :living_tv
      t.string :living_other
      t.integer :base_salon
      t.integer :base_shelf
      t.integer :base_desk
      t.integer :base_training
      t.string :base_other
      t.integer :outside_tire
      t.integer :outside_lawn_mower
      t.integer :outside_bike
      t.integer :outside_table
      t.integer :outside_bbq
      t.string :outside_other
      t.integer :quote_id

      t.timestamps
    end
  end
end
