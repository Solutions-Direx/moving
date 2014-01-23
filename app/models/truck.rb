class Truck < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :account


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessible :name, :plate, :available


  # SCOPES
  # ------------------------------------------------------------------------------------------------------
  scope :available, where(available: true)
  scope :sorted, :order => "name"

  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def name_with_plate
    "#{name} (#{plate})"
  end

end
