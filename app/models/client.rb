class Client < ActiveRecord::Base
  include PgSearch
  multisearchable :against => [:name, :phone1, :phone2, :code]
  pg_search_scope :search_by_keyword, 
                  :against => [:name, :phone1, :phone2, :code], 
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
  
  attr_accessible :email, :name, :phone1, :phone2, :account_id, :address_attributes, :commercial, :billing_contact, :code
  
  validates_presence_of :name, :phone1
  validates_uniqueness_of :phone1 
  
  scope :commercial, where(commercial: true)
  
  before_create :generate_code
  
private
  
  def generate_code
    last_client_id = Client.last.present? ? Client.last.id : 0
    self.code = "%05d" % (last_client_id + 1)
  end
  
end
