class Storage < ActiveRecord::Base
  has_one :address, :as => :addressable, :dependent => :destroy
  accepts_nested_attributes_for :address
  belongs_to :account
  has_many :annexes, :dependent => :destroy
  
  attr_accessible :account_id, :internal, :name, :price, :address_attributes
  
  validates :name, :presence => true, :uniqueness => true
  
  default_scope :order => "name"
end
