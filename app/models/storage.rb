class Storage < ActiveRecord::Base
  has_one :address, :as => :addressable, :dependent => :destroy
  accepts_nested_attributes_for :address
  belongs_to :account
  
  attr_accessible :account_id, :default, :name, :address_attributes
  
  validates :name, :presence => true, :uniqueness => true
end
