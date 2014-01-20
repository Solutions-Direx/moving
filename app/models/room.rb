class Room < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :quote

  
  # CONSTANTS
  # ------------------------------------------------------------------------------------------------------
  SIZES = %w{small medium large}


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessor :bypass_validation
  attr_accessible :comment, :size, :quote_id


  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :size, :if => lambda { |a| a.bypass_validation.blank? }

end
