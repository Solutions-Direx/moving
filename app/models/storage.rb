class Storage < ActiveRecord::Base
  has_one :address, :as => :addressable, :dependent => :destroy
  #accepts_nested_attributes_for :addresses, :allow_destroy => true
  belongs_to :account
  
  attr_accessible :account_id, :default, :name
  
  validates_presence_of :name
end
