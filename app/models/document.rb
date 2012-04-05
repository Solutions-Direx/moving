class Document < ActiveRecord::Base
  belongs_to :account
  
  attr_accessible :body, :name
  
  validates_presence_of :account_id, :body, :name
  validates_uniqueness_of :name
end
