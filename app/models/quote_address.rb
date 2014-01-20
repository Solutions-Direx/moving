class QuoteAddress < ActiveRecord::Base

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :quote
  belongs_to :storage


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessible :quote_id, :type, :address_attributes, :storage_id, :insurance, :price


  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def has_storage?
    !storage_id.blank?
  end
  
  def self.static_map_link(from, to, options={})
    from_address = from.has_storage? ? from.storage.address : from.address
    from_marker = "markers=" + "color:blue|label:D|#{from_address.map_location}"
    to_address = to.has_storage? ? to.storage.address : to.address
    to_marker = "markers=" + "color:purple|label:A|#{to_address.map_location}"
    default_options = {
      size: '200x200',
      maptype: 'roadmap',
      sensor: false
    }
    "http://maps.google.com/maps/api/staticmap?#{from_marker}&#{to_marker}&#{default_options.merge(options).to_param}"
  end
  
  def self.driving_direction_link(from, to, options={})
    from_address = from.has_storage? ? from.storage.address : from.address
    to_address = to.has_storage? ? to.storage.address : to.address
    default_options = {
      maptype: 'roadmap',
      saddr: "\"#{from_address.map_location}\"",
      daddr: "\"#{to_address.map_location}\""
    }
    "https://maps.google.com/maps?#{default_options.merge(options).to_param}"
  end
  
end