class Storage < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address
  belongs_to :account
  has_many :annexes, dependent: :destroy


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessible :account_id, :internal, :name, :price, :address_attributes, :insurance_amount


  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates :name, presence: true, uniqueness: true


  # SCOPES
  # ------------------------------------------------------------------------------------------------------
  default_scope :order => "name"

end
