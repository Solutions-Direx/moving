class Removal < ActiveRecord::Base
  belongs_to :quote
  has_one :invoice
  attr_accessible :franchise_cancellation, :insurance_increase, :insurance_limit_enough, 
                  :payment_method, :quote_id, :signature, :signer_name
end
