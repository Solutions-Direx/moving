class Address < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :addressable, :polymorphic => true
  
  # ATTRIBUTES
  attr_accessible :address, :addressable_id, :addressable_type, :city, :country, :postal_code, :province
  
  # VALIDATIONS
  validates :address, :addressable_id, :addressable_type, :city, :postal_code, :province, :presence => true
end
