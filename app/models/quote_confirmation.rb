# encoding: utf-8
class QuoteConfirmation < ActiveRecord::Base
    
  belongs_to :quote
  belongs_to :user
  
  attr_accessible :approved_at, :quote_id, :user_id, :payment_method, :franchise_cancellation, :insurance_limit_enough, :insurance_increase
  
  validates_presence_of :payment_method, :franchise_cancellation, :insurance_limit_enough
end
