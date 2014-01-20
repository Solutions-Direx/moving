class QuoteTruck < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :quote
  belongs_to :truck


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessible :quote_id, :truck_id

end
