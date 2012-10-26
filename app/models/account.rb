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
  has_many :reports, :through => :quotes
  has_many :payments, :through => :invoices

  has_many :taxes, :dependent => :destroy
  accepts_nested_attributes_for :taxes, :reject_if => Proc.new{|t| t['province'].blank? && t['tax1_label'].blank? && t['tax1'].blank? && t['tax2_label'].blank? && t['tax2'].blank? }
  
  # ATTRIBUTES
  attr_accessible :franchise_cancellation_amount, :companies_attributes,
                  :insurance_coverage_short_distance, :insurance_coverage_long_distance, :invoice_start_number, :taxes_attributes,
                  :accounting_moving_account_number, :accounting_tip_account_number, :accounting_insurance_account_number, :accounting_supply_account_number,
                  :accounting_payment_cash_account_number, :accounting_payment_debit_account_number, :accounting_payment_credit_account_number, :accounting_payment_cheque_account_number
  
  # VALIDATIONS
  validates :invoice_start_number, :presence => true, :uniqueness => true
  validates_presence_of :franchise_cancellation_amount
  
  def owner
    users.account_owner.first
  end

end