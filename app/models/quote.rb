class Quote < ActiveRecord::Base
  STATUSES = %w{ Pending Confirmed }
  
  # ASSOCIATIONS
  belongs_to :account
  belongs_to :client
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  
  has_many :rooms, :dependent => :destroy
  accepts_nested_attributes_for :rooms, :reject_if => lambda {|room| room.size.blank?}, :allow_destroy => true
  
  has_one :furniture, :dependent => :destroy
  accepts_nested_attributes_for :furniture
  
  has_many :quote_trucks, :dependent => :destroy
  has_many :trucks, :through => :quote_trucks
  
  has_one :from_address, :class_name => "QuoteFromAddress", :foreign_key => "quote_id", :dependent => :destroy, :dependent => :destroy
  accepts_nested_attributes_for :from_address
  
  has_many :to_addresses, :class_name => "QuoteToAddress", :foreign_key => "quote_id", :dependent => :destroy, :dependent => :destroy
  accepts_nested_attributes_for :to_addresses, :allow_destroy => true
  
  # ATTRIBUTES
  attr_accessible :client_id, :creator_id, :date, :gas, :insurance, :is_house, 
                  :materiel, :num_of_removal_man, :price, :rating, :removal_at, 
                  :transport_time, :rooms_attributes, :comment, :truck_ids, :from_address_attributes, :phone1, :phone2, 
                  :furniture_attributes, :to_addresses_attributes, :removal_at_picker
  
  # VALIDATIONS
  validates_presence_of :removal_at_picker, :removal_at, :account, :creator, :client
  validate :validate_addresses
  # validate :validate_from_address
  
  # CALLBACKS
  before_create :generate_code
  before_save :ignore_blank_addresses, :ignore_blank_rooms
  
  STATUSES.each do |method|
   define_method "#{method.downcase}?" do
      self.status == method
   end
  end
  
  def bypass_validations
    to_addresses.each do |to_address|
      to_address.address.bypass_validation = "1" if to_address.has_storage? || to_address.address.all_blank?
    end
    from_address.address.bypass_validation = "1" if from_address.has_storage?
    rooms.each do |room|
      room.bypass_validation = "1" if room.size.blank?
    end
  end
  
  def removal_at_picker
    removal_at
  end
  
  def removal_at_picker=(datetime)
    self.removal_at = datetime[:date].blank? ? '' : Time.zone.parse("#{datetime[:date]} #{datetime[:hour]}:#{datetime[:minute]}")
  end
  
  
private

  def generate_code
    self.code = Array.new.tap {|a| 5.times { a << (0..9).to_a.sample } }.join
  end
  
  def ignore_blank_addresses
    tmp = to_addresses.clone
    tmp.each do |to_address|
      to_addresses.delete(to_address) if !to_address.has_storage? && to_address.address.all_blank?
    end
    
  end
  
  def ignore_blank_rooms
    copy = rooms.clone
    copy.each do |room|
      rooms.delete(room) if room.size.blank?
    end
  end
  
  def validate_addresses
    if from_address && from_address.address.all_blank?
      errors.add(:base, "From address cannot be blank")
    else
      errors.add(:base, "To address cannot be blank") if to_addresses.blank?
    end
  end
  
end
