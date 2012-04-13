class QuoteAddress < ActiveRecord::Base
  belongs_to :quote
  belongs_to :storage
    
  attr_accessible :quote_id, :type, :address_attributes, :storage_id
  
  def has_storage?
    !storage_id.blank?
  end
  
end