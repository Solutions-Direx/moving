# encoding: utf-8
class Address < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :addressable, :polymorphic => true
  
  # ATTRIBUTES
  attr_accessor :bypass_validation
  attr_accessible :address, :addressable_id, :addressable_type, :city, :country, :postal_code, :province, :bypass_validation
  
  # VALIDATIONS
  validates :address, :city, :province, :presence => true, :if => lambda {|a| a.bypass_validation.blank?}
  validates_presence_of :address, :if => lambda {|a| a.bypass_validation.blank?}
  
  PROVINCE = ['Québec', 'Ontario', 'Alberta', 'British Columbia', 'Manitoba', 'New Brunswick', 'Newfoundland and Labrador', 'Northwest Territories', 'Nova Scotia',
             'Nunavut', 'Prince Edward Island', 'Saskatchewan', 'Yukon', 'Alabama', 'Alaska', 'Arizona', 'Arkansas', 
             'California', 'Colorado','Connecticut', 'Delaware', 'District of Columbia', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 
             'Indiana', 'Iowa','Kansas', 'Kentucky','Louisiana', 'Maine','Maryland', 'Massachusetts', 'Michigan','Minnesota','Mississippi',
             'Missouri', 'Montana','Nebraska', 'Nevada','New Hampshire', 'New Jersey','New Mexico','New York', 'North Carolina', 'North Dakota', 
             'Ohio','Oklahoma', 'Oregon','Pennsylvania','Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont', 
             'Virginia', 'Washington', 'WestVirginia', 'Wisconsin','Wyoming'
             ]
  
  COUNTRY = ['Canada', 'USA']
  
  def all_blank?
    attributes.except("addressable_type").values.compact.reject{|s| s.blank?}.empty?
  end
  
  def get_directions
    link = "http://maps.google.com/maps?q=#{map_location}"
  end
  
  def map_location
    "#{address},#{city},#{province},#{country}"
  end
  
  def to_s
    "#{address}, #{city}, #{province}, #{postal_code}"
  end
  
  def street_and_city
    "#{address} - #{city}"
  end
  
  def copy_from_address(address)
    self.address = address.address
    self.city = address.city
    self.province = address.province
    self.postal_code = address.postal_code
    self.country = address.country
  end

end