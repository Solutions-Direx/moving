class Quote < ActiveRecord::Base
  
  belongs_to :account
  belongs_to :client
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  has_many :rooms, :dependent => :destroy
  accepts_nested_attributes_for :rooms, :reject_if => proc {|room| room.size.blank?}
  has_one :furniture, :dependent => :destroy
  accepts_nested_attributes_for :furniture
  
  has_many :quote_trucks, :dependent => :destroy
  has_many :trucks, :through => :quote_trucks
  
  has_one :from_address, :class_name => "Address", :as => :addressable, :dependent => :destroy
  accepts_nested_attributes_for :from_address
  
  has_many :to_addresses, :class_name => "Address", :as => :addressable, :dependent => :destroy
  accepts_nested_attributes_for :to_addresses, :reject_if => :all_blank
  
  attr_accessible :client_id, :creator_id, :date, :gas, :insurance, :is_house, 
                  :materiel, :num_of_removal_man, :price, :rating, :removal_at, 
                  :transport_time, :rooms_attributes, :comment, :truck_ids, :from_address_attributes, :phone1, :phone2, :furniture_attributes
  
  validates_presence_of :account, :creator, :client
end
