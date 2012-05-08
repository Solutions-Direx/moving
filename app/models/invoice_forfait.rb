class InvoiceForfait < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :forfait
  attr_accessible :forfait_id, :invoice_id
end
