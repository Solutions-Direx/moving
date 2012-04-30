# encoding: utf-8
class Address < ActiveRecord::Base
  # ASSOCIATIONS
  belongs_to :addressable, :polymorphic => true
  
  # ATTRIBUTES
  attr_accessor :bypass_validation
  attr_accessible :address, :addressable_id, :addressable_type, :city, :country, :postal_code, :province, :bypass_validation
  
  # VALIDATIONS
  validates :address, :city, :postal_code, :presence => true, :if => lambda {|a| a.bypass_validation.blank?}
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
    location = "#{address}, #{city}, #{province}"
    link = "http://maps.google.com/maps?q=#{location}"
  end
  
end