class Invoice < ActiveRecord::Base
  include Signable
  include PgSearch
  multisearchable :against => [:code]
  pg_search_scope :search_by_keyword, 
                  :against => :code,
                  :associated_against  => {
                    :quote => :code,
                    :client => :name
                  },
                  :using => { 
                    :tsearch => {
                      :prefix => true # match any characters
                    } 
                  },
                  :ignoring => :accents
                  
  belongs_to :quote
  belongs_to :client
  
  has_many :invoice_forfaits, :dependent => :destroy
  has_many :forfaits, :through => :invoice_forfaits

  has_many :payments, :dependent => :destroy
  accepts_nested_attributes_for :payments, :allow_destroy => true, :reject_if => lambda {|p| p['amount'].blank? && p['date'].blank? && p['payment_method'].blank?}
  
  has_one :account, :through => :quote
  
  has_many :invoice_supplies, :dependent => :destroy
  has_many :supplies, :through => :invoice_supplies
  accepts_nested_attributes_for :invoice_supplies, :allow_destroy => true, :reject_if => lambda {|qs| qs[:quantity].blank? || qs[:supply_id].blank?}
  
  has_many :overtimes, :dependent => :destroy
  accepts_nested_attributes_for :overtimes, :allow_destroy => true, :reject_if => :all_blank
  
  attr_accessible :comment, :signature, :signer_name, :time_spent, :quote_id, :gas, :rate, :overtime, :overtime_rate,
                  :invoice_supplies_attributes, :forfait_ids, :client_satisfaction,
                  :payment_method, :discount, :credit_card_type, :overtimes_attributes, :lock_version,
                  :too_big_for_stairway, :too_big_for_hallway, :too_big, :broken, :too_fragile, :furnitures, :tip
  
  before_create :generate_code
  
  validates_presence_of :payment_method, :unless => Proc.new { |invoice| invoice.quote.client.commercial? }

  # cache grand_total calculation since it's expensive
  # pass recalculate = true to recalculate
  def grand_total(recalculate = false)
    if @grand_total.nil? || recalculate
      @grand_total = total_time_spent + (try(:gas) || 0) + total_overtime + total_supplies + total_forfaits + total_franchise_cancellation + total_insurance_increase - total_discount
      @grand_total = 0 if @grand_total < 0
    end
    @grand_total
  end
  
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
    t = total_with_tax + (try(:tip) || 0).round(2)
    t -= quote.deposit.amount if quote.deposit
    t = 0 if t < 0
    t
  end

  def total_with_tax
    grand_total + tax_amount
  end

  def tax_amount
    (grand_total * (tax_rate / 100)).round(2)
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
    
    # get tax base on client province
    copy_tax_setting(quote)
  end

  def copy_tax_setting(quote)
    client_province = quote.client.address.province
    if client_province.present?
      # try to find tax setting from client province
      province_tax = Tax.where(province: client_province, account_id: quote.account_id).first
      if province_tax.present?
        self.tax_name = province_tax.tax_name
        self.tax_rate = province_tax.tax_rate
      else
        # use default tax
        default_tax = Tax.default_tax
        self.tax_name = default_tax.tax_name
        self.tax_rate = default_tax.tax_rate
      end
    else
      # use default tax
      default_tax = Tax.default_tax
      self.tax_name = default_tax.tax_name
      self.tax_rate = default_tax.tax_rate
    end
  end
  
private

  def generate_code
    last_invoice = Invoice.last
    account = quote.company.account
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