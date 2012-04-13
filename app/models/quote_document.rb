class QuoteDocument < ActiveRecord::Base
  belongs_to :quote
  belongs_to :document
  attr_accessible :document_id, :quote_id
end
