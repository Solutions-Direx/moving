class QuoteSupply < ActiveRecord::Base
  belongs_to :quote
  belongs_to :supply
  attr_accessible :quantity, :quote_id, :supply_id
  
  validates_presence_of :quantity
end