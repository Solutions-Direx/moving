class QuoteForfait < ActiveRecord::Base
  belongs_to :quote
  belongs_to :forfait
  attr_accessible :forfait_id, :quote_id
end
