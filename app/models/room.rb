class Room < ActiveRecord::Base
  belongs_to :quote
  
  SIZES = %w{small medium large}
  
  attr_accessor :bypass_validation
  attr_accessible :comment, :size, :quote_id
  
  validates_presence_of :size, :if => lambda {|a| a.bypass_validation.blank?}
end
