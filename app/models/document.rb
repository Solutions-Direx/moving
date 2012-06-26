class Document < ActiveRecord::Base
  belongs_to :account
  
  attr_accessible :body, :name, :default
  
  validates_presence_of :account_id, :body, :name
  validates_uniqueness_of :name
  
  default_scope :order => "name"
  scope :default, where(default: true)
  
end
