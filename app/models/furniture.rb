class Furniture < ActiveRecord::Base
  belongs_to :quote
  
  attr_accessible :num_appliances, :num_boxes, :kitchen_table, :kitchen_chair, :kitchen_buffet, :living_couch_3pl, :living_couch_2pl, 
                  :living_armchair, :living_table, :living_wall_unit, :living_tv, :living_other, :base_salon, :base_shelf, :base_desk, 
                  :base_training, :base_other, :outside_tire, :outside_lawn_mower, :outside_bike, :outside_table, :outside_bbq, :outside_other, 
                  :quote_id
end