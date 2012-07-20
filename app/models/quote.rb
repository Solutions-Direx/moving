# encoding: utf-8
class Quote < ActiveRecord::Base
  include Signable
  include PgSearch
  multisearchable :against => [:code]
  pg_search_scope :search_by_keyword, 
                  :against => :code,
                  :associated_against  => {
                    :client => :name,
                    :creator => [:first_name, :last_name]
                  },
                  :using => { 
                    :tsearch => {
                      :prefix => true # match any characters
                    } 
                  },
                  :ignoring => :accents
  
  STATUSES = %w{pending confirmed rejected}
  
  # ASSOCIATIONS
  belongs_to :account
  belongs_to :company
  belongs_to :client
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :rejector, :class_name => "User", :foreign_key => "rejected_by"
  
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

  has_one :billing_address, :class_name => "QuoteBillingAddress", :foreign_key => "quote_id", :dependent => :destroy
  accepts_nested_attributes_for :billing_address
  
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
  
  has_one :invoice, :dependent => :destroy
  accepts_nested_attributes_for :invoice
  
  has_one :report, :dependent => :destroy
  accepts_nested_attributes_for :report
  
  has_one :deposit, :class_name => "QuoteDeposit", :dependent => :destroy
  accepts_nested_attributes_for :deposit
  
  # ATTRIBUTES
  attr_accessible :client_id, :creator_id, :date, :gas, :insurance, :is_house, :rejected_by, :rejected_at,
                  :materiel, :num_of_removal_man, :price, :rating, :removal_at, :company_id,
                  :transport_time, :rooms_attributes, :comment, :truck_ids, :from_address_attributes, :phone1, :phone2, 
                  :furniture_attributes, :to_addresses_attributes, :removal_at_picker, :removal_at_comment, 
                  :document_ids, :forfait_ids, :quote_supplies_attributes, :pm, :long_distance, :lock_version,
                  :removal_leader_id, :removal_man_ids, :internal_address, :invoice_attributes, :signer_name, :signature, :contact
  
  # VALIDATIONS
  validates_presence_of :removal_at_picker, :removal_at, :company_id, :creator, :client
  validate :validate_addresses
  validates_uniqueness_of :code
  
  # CALLBACKS
  before_create :generate_code, :copy_billing_address
  before_save :ignore_blank_addresses, :ignore_blank_rooms
  
  # SCOPES
  scope :pending, where(:status => 'pending')
  scope :confirmed, where(:status => 'confirmed')
  scope :rejected, where(:status => 'rejected')
  scope :applicable, where(:status => ['pending', 'confirmed'])
  scope :today, lambda { where("removal_at BETWEEN '#{Date.today.beginning_of_day.utc}' AND '#{Date.today.end_of_day.utc}'") }
  scope :by_day, lambda { |day| where("removal_at BETWEEN '#{day.beginning_of_day.utc}' AND '#{day.end_of_day.utc}'") }
  
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
    "#{I18n.t 'approved_on'} #{I18n.l(quote_confirmation.approved_at, :format => :long)} #{I18n.t 'by'} #{quote_confirmation.user.full_name}"
  end

  def tax
    tax = Tax.default_tax
    client_province = billing_address.address.province
    if client_province.present?
      province_tax = Tax.find_by_province(client_province)
      if province_tax.present?
        tax = province_tax
      end
    end
    tax
  end
  
private

  def generate_code
    last_quote_id = Quote.last.present? ? Quote.last.id : 0
    self.code = "%06d" % (last_quote_id + 1)
  end

  def copy_billing_address
    client_address = client.address
    ba = self.build_billing_address
    ba.build_address({
      address: client_address.address,
      city: client_address.city,
      province: client_address.province,
      postal_code: client_address.postal_code,
      country: client_address.country
    })
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
      errors.add(:base, "#{I18n.t 'from_address_cannot_be_blank', default: 'From address cannot be blank'}")
    end
  end
  
end