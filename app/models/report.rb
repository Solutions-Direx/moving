class Report < ActiveRecord::Base
  belongs_to :quote
  attr_accessible :distance_in_nb, :distance_in_on, :distance_in_qc, :distance_other, 
                  :end_time, :gas, :km_end, :km_start, :quote_id, :signature, :signer_name, :start_time, :comment
  
  def signed?
    !signer_name.blank? && !signature.blank?
  end
  
  def total_km
    (try(:km_start) || 0) + (try(:km_end) || 0)
  end
end
