class Account < ActiveRecord::Base
  
  # ASSOCIATIONS
  has_many :users, :dependent => :destroy
  has_many :documents, :dependent => :destroy
  has_many :storages, :dependent => :destroy
  has_many :clients, :dependent => :destroy
  has_many :supplies, :dependent => :destroy
  has_many :trucks, :dependent => :destroy
  has_many :forfaits, :dependent => :destroy
  has_many :companies, :dependent => :destroy
  accepts_nested_attributes_for :companies, :reject_if => Proc.new{|t| t['company_name'].blank? && t['email'].blank? && t['phone'].blank? && t['website'].blank?}
  has_many :quotes
  has_many :invoices, :through => :quotes

  has_many :taxes, :dependent => :destroy
  accepts_nested_attributes_for :taxes, :reject_if => Proc.new{|t| t['province'].blank? && t['tax1_label'].blank? && t['tax1'].blank? && t['tax2_label'].blank? && t['tax2'].blank? }
  
  # ATTRIBUTES
  attr_accessible :franchise_cancellation_amount, :companies_attributes,
                  :insurance_coverage_short_distance, :insurance_coverage_long_distance, :invoice_start_number, :taxes_attributes
  
  # VALIDATIONS
  validates :invoice_start_number, :presence => true, :uniqueness => true
  # validate :validate_invoice_number
  
  # CALLBACKS
  # before_save :set_rebase_invoice_number
  
  def owner
    users.account_owner.first
  end
  
  # private
  
  # def set_rebase_invoice_number
  #   if invoice_start_number_changed?
  #     self.rebase_invoice_number = true
  #   end
  # end
  
  # def validate_invoice_number
  #   if invoice_start_number_changed?
  #     last_invoice = invoices.last
  #     if last_invoice
  #       start_number = try(:invoice_start_number) || 0
  #       if start_number < last_invoice.code
  #         errors.add(:invoice_start_number, "have to greater than or equal to #{last_invoice.code}")
  #       end
  #     end
  #   end
  # end
end
