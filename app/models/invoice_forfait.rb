class InvoiceForfait < ActiveRecord::Base

	# ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :invoice
  belongs_to :forfait


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessible :forfait_id, :invoice_id

end
