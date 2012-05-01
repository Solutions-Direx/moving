class Truck < ActiveRecord::Base
  belongs_to :account
  
  attr_accessible :name, :plate, :available
  
  default_scope :order => "name"
  
  scope :available, where(available: true)
  
  def name_with_plate
    "#{name} (#{plate})"
  end
end
