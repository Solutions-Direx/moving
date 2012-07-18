class Tax < ActiveRecord::Base
  include Taxable
  belongs_to :account
  attr_accessible :province, :tax1_label, :tax1, :tax2_label, :tax2, :compound, :is_default

  validates :tax1, :presence => true
  validates :province, :presence => true, :uniqueness => {:scope => :account_id}, :if => Proc.new{|t| !t.is_default}

  default_scope :order => "is_default DESC"

  def self.default_tax
    where(is_default: true).first
  end

  def display_name
    tax1_name +  ", " + tax2_name    
  end
end
