class Truck < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :account


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessible :name, :plate, :available


  # SCOPES
  # ------------------------------------------------------------------------------------------------------
  default_scope :order => "name"
  scope :available, where(available: true)


  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def name_with_plate
    "#{name} (#{plate})"
  end

end
