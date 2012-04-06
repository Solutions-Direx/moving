class Quote < ActiveRecord::Base
  
  belongs_to :account
  belongs_to :client
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  
  attr_accessible :client_id, :date, :gas, :insurance, :is_house, :nb_appliance, :num_of_removal_man, :price, :rating, :removal_at, :transport_at
  
  validates_presence_of :account, :creator, :client, :transport_at
end
