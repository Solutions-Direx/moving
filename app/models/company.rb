class Company < ActiveRecord::Base
  has_attached_file :logo, 
                    :styles => { :thumb => "200x200>" },
                    :url => "/uploads/company/:id/logo/:style/:basename.:extension",
                    :path => ":rails_root/public/uploads/company/:id/logo/:style/:basename.:extension"

  belongs_to :account
  has_many :quotes, :dependent => :destroy
  has_many :invoices, :through => :quotes

  has_one :address, :as => :addressable, :dependent => :destroy
  accepts_nested_attributes_for :address, :reject_if => :all_blank

  attr_accessible :company_name, :logo, :email, :phone, :website, :address_attributes, :active
  validates :company_name, :presence => true, :uniqueness => true

  scope :active, where(active: true)

  after_initialize do |company|
    company.build_address if company.address.blank?
  end
end
