class Payment < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  attr_accessible :amount, :credit_card_type, :date, :payment_method, :transaction_number, :tip

  validates :amount, :date, :payment_method, :invoice_id, :presence => true
  validates :amount, :numericality => { :greater_than => 0 }
  validates_presence_of :credit_card_type, :if => Proc.new{|p| p.payment_method == 'credit'}

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
    amount + (try(:tip) || 0)
  end
  
  def payment_option_details
    if payment_method == "credit"
      if transaction_number.present?
        "#{I18n.t(credit_card_type)} (##{transaction_number})"
      else
        I18n.t(credit_card_type)
      end
    elsif payment_method == "debit"
      if transaction_number.present?
        "#{I18n.t(payment_method)} (##{transaction_number})"
      else
        I18n.t(payment_method)
      end
    else
      I18n.t(payment_method)
    end
  end
  
end