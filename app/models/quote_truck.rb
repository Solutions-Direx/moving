class QuoteTruck < ActiveRecord::Base
  belongs_to :quote
  belongs_to :truck
  attr_accessible :quote_id, :truck_id
end
