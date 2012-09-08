class Payment < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  attr_accessible :amount, :credit_card_type, :date, :payment_method, :transaction_number, :tip

  validates :amount, :date, :payment_method, :invoice_id, :presence => true

  validates :amount, :numericality => { :greater_than => 0 }

  before_save :cleanup

  def cleanup
    # clear transaction number if not credit/debit
    unless ["credit", "debit"].include?(payment_method)
      self.transaction_number = ""
    end
    # clear card type if not credit
    unless payment_method == "credit"
      self.credit_card_type = ""
    end
  end
  
  def total
    tip? ? amount + tip : amount
  end
end
