class Surcharge < ActiveRecord::Base
  belongs_to :surchargeable, :polymorphic => true
  attr_accessible :label, :price

  validates :label, :presence => true
  validates :price, :numericality => { :greater_than => 0 }
end
