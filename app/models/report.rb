class Report < ActiveRecord::Base
  include Signable
  
  belongs_to :quote
  
  has_many :report_removal_men, :dependent => :destroy
  has_many :removal_men, :through => :report_removal_men
  
  attr_accessible :distance_in_nb, :distance_in_on, :distance_in_qc, :distance_other, :removal_man_ids,
                  :gas, :km_start, :km_end, :quote_id, :signature, :signer_name, :start_time, :end_time, :comment
  
  before_validation(:on => :update) do
    if start_time.kind_of?(ActiveSupport::HashWithIndifferentAccess)
      self.start_time = Time.zone.parse("#{Time.zone.now.strftime('%Y/%m/%d')} #{start_time[:hour]}:#{start_time[:minute]}")
      self.end_time = Time.zone.parse("#{Time.zone.now.strftime('%Y/%m/%d')} #{end_time[:hour]}:#{end_time[:minute]}")
    end  
  end
  
  validates_presence_of: :km_start, :km_end, :start_time, :end_time
  
  before_create :copy_quote_removal_men
  
  def total_km
    (try(:km_start) || 0) + (try(:km_end) || 0)
  end
  
  def copy_quote_removal_men
    self.removal_man_ids = quote.quote_removal_men.pluck(:removal_man_id)
  end
end