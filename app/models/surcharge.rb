class Surcharge < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :surchargeable, :polymorphic => true
  attr_accessible :label, :price


  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :label
  validates_numericality_of :price, greater_than: 0

end
