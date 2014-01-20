class QuoteForfait < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :quote
  belongs_to :forfait


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessible :forfait_id, :quote_id

end
