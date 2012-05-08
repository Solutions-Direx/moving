class Invoice < ActiveRecord::Base
  belongs_to :removal
  belongs_to :quote, :touch => true
  
  has_many :invoice_forfaits, :dependent => :destroy
  has_many :forfaits, :through => :invoice_forfaits
  
  has_many :invoice_supplies, :dependent => :destroy
  has_many :supplies, :through => :invoice_supplies
  accepts_nested_attributes_for :invoice_supplies, :allow_destroy => true, :reject_if => lambda {|qs| qs[:quantity].blank?}
  
  attr_accessible :comment, :signature, :signer_name, :time_spent, :quote_id, :removal_id, :gas, :rate, :num_of_overtime_men, :overtime_rate,
                  :invoice_supplies_attributes, :forfait_ids
  
  before_create :copy_quote_info
  
  def signed?
    !signer_name.blank? && !signature.blank?
  end
  
  def grand_total
    total_time_spent + total_overtime + total_supplies + total_forfaits
  end
  
  def total_overtime
    number_or_zero(:overtime_rate) * number_or_zero(:num_of_overtime_men)
  end
  
  def total_time_spent
    number_or_zero(:time_spent) * number_or_zero(:rate)
  end
  
  def total_supplies
    sum = 0
    if invoice_supplies.any?
      invoice_supplies.each do |inv_supply|
        sum += inv_supply.quantity * inv_supply.supply.price
      end
    end
    sum
  end
  
  def total_forfaits
    sum = 0
    if forfaits.any?
      forfaits.each do |forfait|
        sum += forfait.price
      end
    end
    sum
  end
  
  def total_taxes
    0
  end
  
  def total
    grand_total + total_taxes
  end
  
  private
  
  def copy_quote_info
    self.rate = quote.price
    self.gas = quote.gas
    quote.quote_supplies.each do |qs|
      self.invoice_supplies.build(supply_id: qs.supply_id, quantity: qs.quantity)
    end
    quote.quote_forfaits.each do |qf|
      self.invoice_forfaits.build(forfait_id: qf.forfait_id)
    end
  end
  
  def number_or_zero(field)
    try(field) || 0
  end
end
