class Client < ActiveRecord::Base
  belongs_to :account
  has_one :address, :as => :addressable, :dependent => :destroy
  accepts_nested_attributes_for :address
  has_many :quotes, :dependent => :destroy
  
  attr_accessible :email, :name, :phone1, :phone2, :account_id, :address_attributes
  
  validates_presence_of :name, :phone1
  validates_uniqueness_of :name
  
  default_scope :order => "name"
end
