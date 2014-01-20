class QuoteSupply < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :quote
  belongs_to :supply


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessible :quantity, :quote_id, :supply_id


  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------  
  validates_presence_of :quantity
  validates_presence_of :supply_id

end