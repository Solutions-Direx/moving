class Invoice < ActiveRecord::Base
  belongs_to :removal
  belongs_to :quote, :touch => true
  
  attr_accessible :comment, :signature, :signer_name, :time_spent, :quote_id, :removal_id
  
  def signed?
    !signer_name.blank? && !signature.blank?
  end
end
