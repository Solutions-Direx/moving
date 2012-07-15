class Payment < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  attr_accessible :amount, :credit_card_type, :date, :payment_method, :transaction_number

  validates :amount, :date, :payment_method, :invoice_id, :presence => true

  validates :amount, :numericality => { :greater_than => 0 }
end
