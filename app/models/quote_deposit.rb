class QuoteDeposit < ActiveRecord::Base
  belongs_to :quote
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  
  attr_accessible :amount, :date, :payment_method, :quote_id, :credit_card_type, :creator_id
  
  validates_presence_of :amount, :date, :payment_method, :creator_id
  validates :amount, :numericality => { :greater_than => 0 }
  validates_presence_of :credit_card_type, :if => Proc.new{|p| p.payment_method == 'credit'}
  
end