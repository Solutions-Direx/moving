# encoding: utf-8
class Quote < ActiveRecord::Base
  STATUSES = %w{ Pending Confirmed Rejected}
  
  # ASSOCIATIONS
  belongs_to :account
  belongs_to :client
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  
  has_many :rooms, :dependent => :destroy
  accepts_nested_attributes_for :rooms, :reject_if => lambda {|room| room[:size].blank?}, :allow_destroy => true
  
  has_one :furniture, :dependent => :destroy
  accepts_nested_attributes_for :furniture
  
  has_many :quote_trucks, :dependent => :destroy
  has_many :trucks, :through => :quote_trucks
  
  has_many :quote_documents, :dependent => :destroy
  has_many :documents, :through => :quote_documents
  
  has_many :quote_forfaits, :dependent => :destroy
  has_many :forfaits, :through => :quote_forfaits
  
  has_one :from_address, :class_name => "QuoteFromAddress", :foreign_key => "quote_id", :dependent => :destroy
  accepts_nested_attributes_for :from_address
  
  has_many :to_addresses, :class_name => "QuoteToAddress", :foreign_key => "quote_id", :dependent => :destroy
  accepts_nested_attributes_for :to_addresses, :allow_destroy => true
  
  has_many :quote_supplies, :dependent => :destroy
  has_many :supplies, :through => :quote_supplies
  accepts_nested_attributes_for :quote_supplies, :allow_destroy => true, :reject_if => lambda {|qs| qs[:quantity].blank?}
  
  belongs_to :removal_leader, :class_name => "User", :foreign_key => "removal_leader_id"
  
  has_many :quote_removal_men, :dependent => :destroy
  has_many :removal_men, :through => :quote_removal_men
  
  has_one :quote_confirmation, :dependent => :destroy
  has_one :removal, :dependent => :destroy
  
  has_one :invoice, :dependent => :destroy
  accepts_nested_attributes_for :invoice
  
  has_one :report, :dependent => :destroy
  accepts_nested_attributes_for :report
  
  has_many :tucks, :through => :quote_trucks
  
  # ATTRIBUTES
  attr_accessible :client_id, :creator_id, :date, :gas, :insurance, :is_house, 
                  :materiel, :num_of_removal_man, :price, :rating, :removal_at, 
                  :transport_time, :rooms_attributes, :comment, :truck_ids, :from_address_attributes, :phone1, :phone2, 
                  :furniture_attributes, :to_addresses_attributes, :removal_at_picker, :removal_at_comment, 
                  :document_ids, :forfait_ids, :quote_supplies_attributes, :pm, :long_distance, 
                  :removal_leader_id, :removal_man_ids, :internal_address, :invoice_attributes
  
  # VALIDATIONS
  validates_presence_of :removal_at_picker, :removal_at, :account, :creator, :client
  validate :validate_addresses
  validates_uniqueness_of :code
  
  # CALLBACKS
  before_create :generate_code
  before_save :ignore_blank_addresses, :ignore_blank_rooms
  
  # SCOPES
  scope :pending, where(:status => 'Pending')
  scope :confirmed, where(:status => 'Confirmed')
  scope :rejected, where(:status => 'Rejected')
  scope :applicable, where(:status => ['Pending', "Confirmed"])
  scope :today, lambda { where("removal_at BETWEEN '#{Date.today.beginning_of_day}' AND '#{Date.today.end_of_day}'") }
  
  # define pending?, confirmed? and rejected?
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
  
  def conf_details
    "Approuvée le #{I18n.l(quote_confirmation.approved_at, :format => :long)} par #{quote_confirmation.user.full_name}"
  end
  
  def signed?
    !removal.blank? && !removal.signer_name.blank? && !removal.signature.blank?
  end
  
private

  def generate_code
    self.code = Array.new.tap {|a| 5.times { a << Random.rand(9) } }.join("")
  end
  
  def ignore_blank_addresses
    if internal_address?
      to_addresses.each do |to_address|
        to_address.mark_for_destruction
      end
    else
      tmp = to_addresses.clone
      tmp.each do |to_address|
        to_addresses.delete(to_address) if !to_address.has_storage? && to_address.address.all_blank?
      end
      to_addresses.each do |to_address|
        to_address.address = nil if to_address.has_storage?
      end
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
    end
  end
  
end