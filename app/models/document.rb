class Document < ActiveRecord::Base

	# ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :account
  

  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessible :body, :name, :default
  

  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :account_id, :body, :name
  validates_uniqueness_of :name
  

  # SCOPES
  # ------------------------------------------------------------------------------------------------------
  default_scope :order => "name"
  scope :default, where(default: true)
  
end
