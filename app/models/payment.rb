class Payment < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :payable, polymorphic: true
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  has_one :client, through: :invoice
  

  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessible :amount, :credit_card_type, :date, :payment_method, :transaction_number, :tip


  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :amount, :date, :payment_method
  validates_numericality_of :amount, greater_than: 0
  validates_presence_of :credit_card_type, :if => Proc.new{|p| p.payment_method == 'credit'}


  # CALLBACKS
  # ------------------------------------------------------------------------------------------------------
  before_save :cleanup


  # SCOPES
  # ------------------------------------------------------------------------------------------------------
  scope :today, lambda { where(date: Date.today) }
  scope :by_day, lambda { |day| where("date BETWEEN '#{day.beginning_of_day}' AND '#{day.end_of_day}'") }


  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
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
    amount
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