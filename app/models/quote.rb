class Quote < ActiveRecord::Base
  STATUSES = %w{ Pending Confirmed }
  
  belongs_to :account
  belongs_to :client
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :storage
  
  has_many :rooms, :dependent => :destroy
  accepts_nested_attributes_for :rooms, :reject_if => lambda {|room| room.size.blank?}
  has_one :furniture, :dependent => :destroy
  accepts_nested_attributes_for :furniture
  
  has_many :quote_trucks, :dependent => :destroy
  has_many :trucks, :through => :quote_trucks
  
  has_one :from_address, :class_name => "QuoteFromAddress", :foreign_key => "quote_id", :dependent => :destroy, :dependent => :destroy
  accepts_nested_attributes_for :from_address
  
  has_one :to_address1, :class_name => "QuoteToAddress1", :foreign_key => "quote_id", :dependent => :destroy, :dependent => :destroy
  accepts_nested_attributes_for :to_address1
  
  has_one :to_address2, :class_name => "QuoteToAddress2", :foreign_key => "quote_id", :dependent => :destroy, :dependent => :destroy
  accepts_nested_attributes_for :to_address2
  
  attr_accessible :client_id, :creator_id, :date, :gas, :insurance, :is_house, 
                  :materiel, :num_of_removal_man, :price, :rating, :removal_at, 
                  :transport_time, :rooms_attributes, :comment, :truck_ids, :from_address_attributes, :phone1, :phone2, 
                  :furniture_attributes, :to_address1_attributes, :to_address2_attributes, :storage_id
  
  validates_presence_of :account, :creator, :client
  before_create :generate_code
  before_save :ignore_blank_addresses
  
  STATUSES.each do |method|
   define_method "#{method.downcase}?" do
      self.status == method
   end
  end
  
  def bypass_to_addresses_validation
    to_address1.address.bypass_validation = "1" if to_address1.address.all_blank?
    to_address2.address.bypass_validation = "1" if to_address2.address.all_blank?
  end
  
private
  def generate_code
    self.code = Devise.friendly_token.downcase
  end
  
  def ignore_blank_addresses
    self.to_address1 = nil if to_address1.address.bypass_validation
    self.to_address2 = nil if to_address2.address.bypass_validation
  end
end
