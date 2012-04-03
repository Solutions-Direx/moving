class Account < ActiveRecord::Base
  # ASSOCIATIONS
  has_many :users, :dependent => :destroy
  
  # ATTRIBUTES
  attr_accessible :company_name
  
  # VALIDATIONS
  validates :company_name, :presence => true, :uniqueness => true
  
  def owner
    users.account_owner.first
  end
end
