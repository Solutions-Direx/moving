# encoding: utf-8
class QuoteConfirmation < ActiveRecord::Base
    
  belongs_to :quote
  belongs_to :user
  
  attr_accessible :approved_at, :quote_id, :user_id, :payment_method, :franchise_cancellation, :insurance_limit_enough, :insurance_increase
  
  validates_presence_of :payment_method, :if => lambda {|q| !q.quote.client.commercial? }
  validates_presence_of :insurance_increase, :if => lambda {|q| !q.insurance_limit_enough }
  validates_inclusion_of :franchise_cancellation, :insurance_limit_enough, :in => [true,false]
  
  after_create :mark_quote_confirmed
  
  def mark_quote_confirmed
    quote.status = "confirmed"
    quote.save
  end
end