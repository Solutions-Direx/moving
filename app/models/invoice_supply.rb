class InvoiceSupply < ActiveRecord::Base

	# ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :invoice
  belongs_to :supply


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessible :invoice_id, :quantity, :supply_id
  

  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :quantity

end
