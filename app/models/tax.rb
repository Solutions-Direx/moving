class Tax < ActiveRecord::Base
  include Taxable

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
  belongs_to :account


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  attr_accessible :province, :tax1_label, :tax1, :tax2_label, :tax2, :compound, :is_default


  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_presence_of :tax1
  validates :province, presence: true, uniqueness: {scope: :account_id}, :if => Proc.new{|t| !t.is_default}


  # SCOPES
  # ------------------------------------------------------------------------------------------------------
  default_scope :order => "is_default DESC"


  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def self.default_tax
    where(is_default: true).first
  end

  def display_name
    tax1_name +  ", " + tax2_name    
  end

end
