class Client < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:name, :phone1, :phone2]
  pg_search_scope :search_by_keyword, 
                  :against => :name, 
                  :using => { 
                    :tsearch => {
                      :prefix => true # match any characters
                    } 
                  },
                  :ignoring => :accents
  
  belongs_to :account
  has_one :address, :as => :addressable, :dependent => :destroy
  accepts_nested_attributes_for :address
  has_many :quotes, :dependent => :destroy
  
  attr_accessible :email, :name, :phone1, :phone2, :account_id, :address_attributes, :commercial
  
  validates_presence_of :name, :phone1
  validates_uniqueness_of :name
  
  scope :commercial, where(commerical: true)
  
end
