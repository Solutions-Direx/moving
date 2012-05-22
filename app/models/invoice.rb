class Invoice < ActiveRecord::Base
  include Taxable
  include Signable
  include PgSearch
  multisearchable :against => [:code]
  
  belongs_to :quote, :touch => true
  
  has_many :invoice_forfaits, :dependent => :destroy
  has_many :forfaits, :through => :invoice_forfaits
  
  has_one :account, :through => :quote
  
  has_many :invoice_supplies, :dependent => :destroy
  has_many :supplies, :through => :invoice_supplies
  accepts_nested_attributes_for :invoice_supplies, :allow_destroy => true, :reject_if => lambda {|qs| qs[:quantity].blank? || qs[:supply_id].blank?}
  
  has_many :overtimes, :dependent => :destroy
  accepts_nested_attributes_for :overtimes, :allow_destroy => true, :reject_if => :all_blank
  
  attr_accessible :comment, :signature, :signer_name, :time_spent, :quote_id, :gas, :rate, :overtime, :overtime_rate,
                  :invoice_supplies_attributes, :forfait_ids, :client_satisfaction,
                  :payment_method, :discount, :credit_card_type, :overtimes_attributes
  
  before_create :generate_code
  
  validates_presence_of :payment_method

  # cache grand_total calculation since it's expensive
  # pass recalculate = true to recalculate
  def grand_total(recalculate = false)
    if @grand_total.nil? || recalculate
      @grand_total = total_time_spent + gas + total_overtime + total_supplies + total_forfaits + total_franchise_cancellation + total_insurance_increase - total_discount
      @grand_total = 0 if @grand_total < 0
    end
    @grand_total
  end
  
  # alias subtotal for Taxable module
  alias :subtotal :grand_total
  
  def total_discount
    number_or_zero(:discount).round(2)
  end
  
  def total_overtime
    sum = 0
    if overtimes.any?
      overtimes.each do |overtime|
        sum += ((overtime.try(:rate) || 0) * (overtime.try(:duration) || 0)).round(2)
      end
    end
    sum.round(2)
  end
  
  def total_time_spent
    (number_or_zero(:time_spent) * number_or_zero(:rate)).round(2)
  end
  
  def total_supplies
    sum = 0
    if invoice_supplies.any?
      invoice_supplies.each do |inv_supply|
        sum += inv_supply.quantity * inv_supply.supply.price
      end
    end
    sum.round(2)
  end
  
  def total_forfaits
    sum = 0
    if forfaits.any?
      forfaits.each do |forfait|
        sum += forfait.price
      end
    end
    sum.round(2)
  end
  
  def total_franchise_cancellation
    quote.quote_confirmation.franchise_cancellation ? quote.account.franchise_cancellation_amount : 0
  end
  
  def total_insurance_increase
    quote.quote_confirmation.insurance_limit_enough ? 0 : (quote.quote_confirmation.try(:insurance_increase) || 0).round(2)
  end
  
  def total
    total_with_taxes
  end
  
  def copy_quote_info
    self.rate = quote.price
    self.gas = quote.gas
    quote.quote_supplies.each do |qs|
      self.invoice_supplies.build(supply_id: qs.supply_id, quantity: qs.quantity)
    end
    quote.quote_forfaits.each do |qf|
      self.invoice_forfaits.build(forfait_id: qf.forfait_id)
    end
    
    # copy tax settings
    copy_tax_setting_from(quote.account)
  end
  
private

  def generate_code
    last_invoice = Invoice.last
    account = quote.account
    # force new invoice code
    if account.rebase_invoice_number
      last_code = account.invoice_start_number
      account.rebase_invoice_number = false
      account.save!(validation: false)
    else
      last_code = last_invoice ? last_invoice.code : account.invoice_start_number
    end
    
    self.code = last_code + 1
  end
  
  def number_or_zero(field)
    try(field) || 0
  end
end