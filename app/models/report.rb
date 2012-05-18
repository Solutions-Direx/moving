class Report < ActiveRecord::Base
  include Signable
  
  belongs_to :quote
  attr_accessible :distance_in_nb, :distance_in_on, :distance_in_qc, :distance_other, 
                  :end_time, :gas, :km_end, :km_start, :quote_id, :signature, :signer_name, :start_time, :comment
  
  before_validation(:on => :update) do
    if start_time.kind_of?(ActiveSupport::HashWithIndifferentAccess)
      self.start_time = Time.zone.parse("#{Time.zone.now.strftime('%Y/%m/%d')} #{start_time[:hour]}:#{start_time[:minute]}")
      self.end_time = Time.zone.parse("#{Time.zone.now.strftime('%Y/%m/%d')} #{end_time[:hour]}:#{end_time[:minute]}")
    end  
  end
  
  def total_km
    (try(:km_start) || 0) + (try(:km_end) || 0)
  end
end
