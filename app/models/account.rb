class Account < ActiveRecord::Base
  include Taxable
  
  # ASSOCIATIONS
  has_many :users, :dependent => :destroy
  has_one :address, :as => :addressable, :dependent => :destroy
  accepts_nested_attributes_for :address, :reject_if => :all_blank
  has_many :documents, :dependent => :destroy
  has_many :storages, :dependent => :destroy
  has_many :clients, :dependent => :destroy
  has_many :supplies, :dependent => :destroy
  has_many :quotes, :dependent => :destroy
  has_many :trucks, :dependent => :destroy
  has_many :forfaits, :dependent => :destroy
  
  # ATTRIBUTES
  attr_accessible :company_name, :logo, :logo_cache, :email, :phone, :website, :tax1_label, :tax1, :tax2_label, :tax2, :compound, :address_attributes
  
  # VALIDATIONS
  validates :company_name, :presence => true, :uniqueness => true
  
  # UPLOADER
  mount_uploader :logo, LogoUploader
  
  def owner
    users.account_owner.first
  end
end
