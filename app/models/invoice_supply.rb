class InvoiceSupply < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :supply
  attr_accessible :invoice_id, :quantity, :supply_id
  
  validates_presence_of :quantity
end
