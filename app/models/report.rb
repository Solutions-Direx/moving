class Report < ActiveRecord::Base
  include Signable

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :quote
  
  has_many :report_removal_men, dependent: :destroy
  has_many :removal_men, through: :report_removal_men
  belongs_to :verificator, class_name: "User", foreign_key: "verificator_id"


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessor :is_verify
  attr_accessible :distance_in_nb, :distance_in_on, :distance_in_qc, :distance_other, :removal_man_ids, :gas, :km_start, :km_end, 
                  :quote_id, :signature, :signer_name, :start_time, :end_time, :comment, :verified, :verificator_id, :verified_at


  # CALLBACKS
  # ------------------------------------------------------------------------------------------------------
  before_validation(on: :update) do
    if start_time.kind_of?(ActiveSupport::HashWithIndifferentAccess)
      self.start_time = Time.zone.parse("#{Time.zone.now.strftime('%Y/%m/%d')} #{start_time[:hour]}:#{start_time[:minute]}")
      self.end_time = Time.zone.parse("#{Time.zone.now.strftime('%Y/%m/%d')} #{end_time[:hour]}:#{end_time[:minute]}")
    end  
  end
  
  before_create :copy_quote_removal_men


  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :km_start, :km_end, :start_time, :end_time, on: :update


  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def total_km
    (try(:km_start) || 0) + (try(:km_end) || 0)
  end
  
  def copy_quote_removal_men
    self.removal_man_ids = quote.quote_removal_men.pluck(:removal_man_id)
  end
  
  def verify_report
    unless verified?
      self.is_verify = true
      self.verified = true
      self.verificator_id = User.current_user.id
      self.verified_at = Time.zone.now
    end
  end

end