class QuoteDeposit < ActiveRecord::Base
  belongs_to :quote
  attr_accessible :amount, :date, :payment_method, :quote_id, :credit_card_type
  
  validates_presence_of :amount, :date, :payment_method
end
