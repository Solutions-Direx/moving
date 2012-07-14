class Tax < ActiveRecord::Base
  belongs_to :account
  attr_accessible :province, :tax_name, :tax_rate, :is_default

  validates :tax_name, :tax_rate, :presence => true
  validates :province, :presence => true, :uniqueness => {:scope => :account_id}, :if => Proc.new{|t| !t.is_default}
end
