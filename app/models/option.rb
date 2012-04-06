class Option < ActiveRecord::Base
  belongs_to :account
  
  attr_accessible :account_id, :active, :name, :price
  
  validates_presence_of :name
  validates_uniqueness_of :name
end
