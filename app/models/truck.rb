class Truck < ActiveRecord::Base
  belongs_to :account
  attr_accessible :name, :plate
  default_scope :order => "name"
  
  def name_with_plate
    "#{name} - #{plate}"
  end
end
