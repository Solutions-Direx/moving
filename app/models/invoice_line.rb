class InvoiceLine < ActiveRecord::Base
	include ActionView::Helpers::NumberHelper

	belongs_to :invoiceable, :polymorphic => true
	belongs_to :invoice
  
  attr_accessible :amount, :invoiceable_id, :invoiceable_type, :invoice_id, :item_name, :quantity
  
  #InvoiceLine Types:
  ## Moving: default. Includes all hours-based (time psent, overtime) conditions, forfaits 
  ## Insurance: insurance from QuoteConfirmation
  ## Tip: not taxable
  ## Supply: related to corresponding model
  scope :moving, where(item_name: "moving")
  scope :gas, where(item_name: "gas")
  scope :insurances, where(item_name: "insurance")
  scope :tips, where(item_name: "tip")
  scope :forfaits, where(item_name: "forfait")
  scope :supplies, where(item_name: "supply")

  def subtotal
  	quantity.present? ? (quantity * amount) : amount
  end
  
  def display
  	quantity.present? ? "(#{number_with_precision(quantity, strip_insignificant_zeros: true)} * #{number_to_currency(amount, strip_insignificant_zeros: true)})" : ""
  end

end