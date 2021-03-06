# encoding: utf-8
class QuoteConfirmation < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :quote
  belongs_to :user


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessible :approved_at, :quote_id, :user_id, :payment_method, :franchise_cancellation, :insurance_limit_enough, :insurance_increase,
                  :tv_insurance, :tv_insurance_price


  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :payment_method, :if => lambda {|q| !q.quote.client.commercial? }
  validates_presence_of :insurance_increase, :if => lambda {|q| !q.insurance_limit_enough }
  validates_presence_of :tv_insurance_price, :if => lambda {|q| q.tv_insurance? }
  validates_inclusion_of :franchise_cancellation, :insurance_limit_enough, :in => [true,false]


  # CALLBACKS
  # ------------------------------------------------------------------------------------------------------
  after_create :mark_quote_confirmed
  after_destroy :delete_quote_confirmation_and_report


  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  private

    def mark_quote_confirmed
      quote.status = "confirmed"
      quote.save
    end

    def delete_quote_confirmation_and_report
      quote.invoice.destroy if quote.invoice
      quote.deposit.destroy if quote.deposit
    end
  
end