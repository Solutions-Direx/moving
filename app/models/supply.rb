class Supply < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :account


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessible :account_id, :active, :name, :price


  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :name, :price
  validates_uniqueness_of :name
 

  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def name_with_price
    "#{name} (#{number_to_currency(price || 0, strip_insignificant_zeros: true)})"
  end

end
