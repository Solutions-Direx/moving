class Account < ActiveRecord::Base
  include Taxable
  
  # ASSOCIATIONS
  has_many :users, :dependent => :destroy
  has_many :addresses, :as => :addressable, :dependent => :destroy
  accepts_nested_attributes_for :addresses, :allow_destroy => true
  has_many :documents, :dependent => :destroy
  has_many :storages, :dependent => :destroy
  
  # ATTRIBUTES
  attr_accessible :company_name, :logo, :logo_cache, :email, :phone, :website, :tax1_label, :tax1, :tax2_label, :tax2, :compound, :addresses_attributes
  
  # VALIDATIONS
  validates :company_name, :presence => true, :uniqueness => true
  
  # UPLOADER
  mount_uploader :logo, LogoUploader
  
  def owner
    users.account_owner.first
  end
end
