class Forfait < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :account
  

  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessible :account_id, :description, :name, :price
  

  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :name, :description, :price
  validates_uniqueness_of :name
  

  # SCOPES
  # ------------------------------------------------------------------------------------------------------
  default_scope :order => "name"
  

  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def name_with_price
    "#{name} (#{number_to_currency(price)})"
  end

end
