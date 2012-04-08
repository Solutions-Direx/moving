class Room < ActiveRecord::Base
  belongs_to :quote
  
  SIZES = %w{Small Medium Large}
  
  attr_accessible :comment, :size, :quote_id
  
  validates_presence_of :size
end
