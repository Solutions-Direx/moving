class Annex < ActiveRecord::Base

	# ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :storage
  

  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessible :body, :name, :storage_id
  

  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :name, :body
  validates_uniqueness_of :name

end
