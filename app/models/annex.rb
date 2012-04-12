class Annex < ActiveRecord::Base
  belongs_to :storage
  
  attr_accessible :body, :name, :storage_id
  
  validates_presence_of :name, :body
  validates_uniqueness_of :name
end
