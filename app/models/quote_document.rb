class QuoteDocument < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :quote
  belongs_to :document


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessible :document_id, :quote_id

end
