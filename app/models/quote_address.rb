class QuoteAddress < ActiveRecord::Base
  belongs_to :quote
  attr_accessible :quote_id, :type, :address_attributes
end